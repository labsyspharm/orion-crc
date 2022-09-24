% BALANCEDIMAGEDATASTORE Balanced datastore for a collection of image files
%
%   BALDS = BalancedImageDatastore(IMDS) creates a BalancedImageDatastore
%   from the given ImageDatastore IMDS
%
%
%   PROPERTIES:
%       
%       Duplicates               - Repetition index for each image
%                                  Duplicates(i) == 0 means the image i is original
%                                  Duplicates(i) == k means the image i is the k-th repetition
%       AlternateFileSystemRoots - Alternate file system root paths for the Files.
%       ReadSize                 - Upper limit on the number of images returned by the read method.
%       Labels                   - A set of labels for images.
%       NumObservations          - Total number of provided images by the datastore
%                                  NumObservations = NumFiles + NumDuplicates
%       NumFiles                 - Number of image files
%       NumDuplicates            - Number of duplicate images
%
%   METHODS:
%
%       hasdata        - Returns true if there is more data in the datastore
%       read           - Reads the next consecutive file
%       reset          - Resets the datastore to the start of the data
%       preview        - Reads the first image from the datastore
%       readall        - Reads all image files from the datastore
%       partition      - Returns a new datastore that represents a single
%                        partitioned portion of the original datastore
%       numpartitions  - Returns an estimate for a reasonable number of
%                        partitions to use with the partition function,
%                        according to the total data size
%       splitEachLabel - Splits the ImageDatastore labels according to the
%                        specified proportions, which can be represented as
%                        percentages or number of files.
%       countEachLabel - Counts the number of unique labels in the datastore
%       shuffle        - Shuffles the files of datastore using randperm
%       transform      - Creates an altered form of the current datastore by
%                        specifying a function handle that will execute
%                        after read on the current datastore.
%       combine        - Creates a new datastore that horizontally
%                        concatenates the result of read from two or more
%                        input datastores.
%
%   Example:
%   --------
%   % Creates two balanced image datasets (80% for training and 20% for test)
%   % where the duplicate images are rotated 10x grades
%   balds = BalancedImageDatastore( ...
%               imageDatastore(dataroot, 'IncludeSubfolders',true, 'LabelSource','foldernames') );
%   [trainds, testds] = balds.transform( ...
%               @(z,i) imrotate(z, i.Duplicate*10), 'IncludeInfo',true ).splitEachLabel(.8);
%   
%   See also ImageDatastore
%   Author: Enrique Dominguez
%     Date: May 2020 (v1.0)
classdef BalancedImageDatastore < ...
        matlab.io.Datastore &...
        matlab.io.datastore.Shuffleable &...
        matlab.io.datastore.Partitionable &...
        matlab.mixin.Copyable
    properties
        % Array of integers, which indicate the number of repetition for
        % each file in the image datastore.
        %   Duplicates(i) == 0 means the image i is original
        %   Duplicates(i) == k means the image i is the k-th repetition
        % This information is also included in the structure returned by 
        % the read method
        Duplicates;
    end
    
    properties (Dependent)
        % Alternative file system root path  for the files
        AlternateFileSystemRoots;
        % Upper limit on the number of images returned by the read method
        ReadSize;
        % Total number of provided images by the datastore 
        % NumObservtions = NumFiles + NumDuplicates
        NumObservations;
        % Number of image files
        NumFiles;
        % Number of duplicate images
        NumDuplicates;
    end
    
    properties (Access = private)
        % Image datastore
        imds;
    end
    
    properties (Access = private, Transient, NonCopyable)
        % Current index of duplicates
        DuplicateIndex = 1;
    end
    
    methods
        % BalancedImageDatastore is constructed from an ImageDatastore by 
        % replicating the lower occurrence image files in order to obtain
        % an equally number of ocurrences for each label
        function self = BalancedImageDatastore(imds)
            
            if ~isa(imds, 'matlab.io.datastore.ImageDatastore')
                error("Datastore must be an ImageDatastore")
            end
            if isempty(imds.Labels)
                error("ImageDatastore must be labelled")
            end
            
            % Balance the image datastore
            info = imds.countEachLabel;
            m = max(info.Count);
            newFiles = cell(height(info),1);
            newLabels = newFiles;
            newDup = newFiles;
            for i = 1:height(info)
                B = imds.Files(imds.Labels==info.Label(i));
                newFiles{i} = [repmat(B, fix(m/info.Count(i)), 1); ...
                    B(randi(info.Count(i), mod(m,info.Count(i)), 1))];
                newLabels{i} = repmat(info.Label(i), size(newFiles{i}));
                newDup{i} = uint16( repmat(0:fix(m/info.Count(i)), info.Count(i), 1) );
                newDup{i} = newDup{i}(1:m);
            end
            self.imds = copy(imds);
            self.imds.Files = cat(1,newFiles{:});
            self.imds.Labels = cat(1,newLabels{:});
            self.Duplicates = cat(2,newDup{:});
        end
        
        function [data, info] = read(self)
            [data, info] = self.imds.read();
            if iscell(data)
                n = length(data);
                info.Duplicates = self.Duplicates(self.DuplicateIndex:self.DuplicateIndex + n-1);
                self.DuplicateIndex = self.DuplicateIndex + n;
            else
                info.Duplicate = self.Duplicates(self.DuplicateIndex);
                self.DuplicateIndex = self.DuplicateIndex + 1;                
            end
            if self.DuplicateIndex > length(self.Duplicates)
                self.DuplicateIndex = 1;
            end
        end
        function reset(self)
            self.imds.reset();
            self.DuplicateIndex = 1;
        end
        
        function bool = hasdata(self)
            bool = self.imds.hasdata();
        end
        function newds = shuffle(self)
            newds = copy(self);
            idx = randperm(self.NumObservations);
            newds.imds.Files = self.imds.Files(idx);
            newds.imds.Labels = self.imds.Labels(idx);
            newds.Duplicates = self.Duplicates(idx);
        end
        
        function subds = partition(self, n, ii)
            if isnumeric(n)
                if (n > self.NumObservations) || (n > self.numpartitions())
                    error("Oversized number of partitions")
                end
                if ii > n
                    error("Partition index must be lower than the number of partitions")
                end
                idx = ii:n:self.NumObservations;
            elseif ischar(n)
                if strcmp(n, 'Duplicates')
                    idx = self.Duplicates==ii;
                    if ~any(idx)
                        error("Duplicate number out of range")
                    end
                elseif strcmp(n, 'Labels')
                    idx = self.imds.Labels==ii;
                    if ~any(idx)
                        error("Label missing")
                    end
                else
                    error("Option '%s' not recognized", n)
                end
            else
                error("Parameters type mismatch")
            end
            subds = copy(self);
            subds.imds.Files = self.imds.Files(idx);
            subds.imds.Labels = self.imds.Labels(idx);
            subds.Duplicates = self.Duplicates(idx);
            subds.reset();
        end
        function [varargout] = splitEachLabel(self, varargin)
            narginchk(2,Inf)
            nargoutchk(0, nargin)
            n = nargout;
            if n == 0
                n = 1;
            end
            if ~all(cellfun(@isnumeric, varargin))
                error("Parameters must be numerical values")
            end
            
            % Calculate the size of partitions
            classes = categories(self.imds.Labels);
            nClasses = length(classes);
            sizeLabel = self.NumObservations/nClasses;
            sizes = cell2mat(varargin);
            if sum(sizes) <= 1
                sizes = fix(sizes.*sizeLabel);
            end
            if sum(sizes) < sizeLabel
                sizes(end+1) = sizeLabel - sum(sizes);
            end
            if sum(sizes) > sizeLabel
                error("Sum of values is greater than the size of each label (%d)", sizeLabel)
            end
            
            varargout = cell(1,n);
            idx = cellfun(@(x) self.imds.Labels==x, classes, 'UniformOutput',false);
            files = cellfun(@(x) self.imds.Files(x), idx, 'UniformOutput',false);
            labels = cellfun(@(x) self.imds.Labels(x), idx, 'UniformOutput',false);
            duplicates = cellfun(@(x) self.Duplicates(x), idx, 'UniformOutput',false);
            for i = 1:n
                newFiles = cellfun(@(x) x(1:sizes(i)), files, 'UniformOutput',false);
                newLabels = cellfun(@(x) x(1:sizes(i)), labels, 'UniformOutput',false);
                newDup = cellfun(@(x) x(1:sizes(i)), duplicates, 'UniformOutput',false);
                for j = 1:nClasses
                    files{j}(1:sizes(i)) = [];
                    labels{j}(1:sizes(i)) = [];
                    duplicates{j}(1:size(i)) = [];
                end
                varargout{i} = copy(self);
                varargout{i}.imds.Files = cat(2, newFiles{:});
                varargout{i}.imds.Labels = cat(2, newLabels{:});
                varargout{i}.Duplicates = cat(2, newDup{:});
                varargout{i}.reset();
            end
        end
        
        function tbl = countEachLabel(self)
            [g, l, d] = findgroups(self.imds.Labels, self.Duplicates' > 0);
            c = splitapply(@numel, self.imds.Labels, g);
            tbl = table(c(~d),... 
                'VariableNames',{'Originals'}, 'RowNames',cellstr(l(~d)));
            tbl{cellstr(l(d)), 'Duplicates'} = c(d);
        end
        
        %------- Dependent methods ----------------------------------------
        
        function aPaths = get.AlternateFileSystemRoots(self)
            aPaths = self.imds.AlternateFileSystemRoots;
        end
        function set.AlternateFileSystemRoots(self, aPaths)
            self.imds.AlternateFileSystemRoots = aPaths;
        end
        
        function readsize = get.ReadSize(self)
            readsize = self.imds.ReadSize;
        end
        function set.ReadSize(self, readsize)
            self.imds.ReadSize = readsize;
        end
        
        function n = get.NumObservations(self)
            n = length(self.imds.Files);
        end
        
        function n = get.NumDuplicates(self)
            n = sum(self.Duplicates > 0);
        end
        
        function n = get.NumFiles(self)
            n = sum(self.Duplicates == 0);
        end
    end
    
    methods (Hidden)
        function frac = progress(self)
            frac = self.imds.progress();
        end
    end
    
    methods (Access = protected)
        function cop = copyElement(obj)
            cop = copyElement@matlab.mixin.Copyable(obj);
            cop.imds = copy(obj.imds);
        end
        
        function n = maxpartitions(self)
            n = self.imds.numpartitions();
        end
        
    end
    
end