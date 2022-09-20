<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));">

{% assign overviews = site.static_files
    | where_exp: "item", "item.path contains 'minerva/P'"
    | where_exp: "item", "item.path contains 'index.html'"
%}

{% for overview in overviews %}
{% assign case_name = overview.path
    | split: '-'
    | last
    | replace: '/index.html', ''
%}
{% assign thumbnail = overview.path
    | replace: 'index.html', 'thumbnail.jpg'
%}

<figure class="figure-story">
    <a href="{{ overview.path | prepend: site.baseurl }}">
        <img src="{{ site.baseurl }}{{ thumbnail }}">
        <figcaption>{{ case_name }}</figcaption>
    </a>
</figure>

{% endfor %}
</div>