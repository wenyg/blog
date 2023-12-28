{#- Website mata -#}
{%- include "./_head/meta.swig" -%}

{#- Website rss -#}
{%- if theme.rss === 'default' and config.feed and config.feed.path -%}
  {{ feed_tag(config.feed.path) }}
{%- elif theme.rss -%}
  {{ feed_tag(theme.rss) }}
{%- else -%}
  {{ feed_tag('atom.xml') }}
{%- endif -%}

{#- Website favicon -#}
{%- if theme.favicon -%}
  <link rel="shortcut icon" type="image/x-icon" href="{{ url_for(theme.favicon) }}?v={{ theme.version }}" />
{%- endif -%}

{#- Canonical, good for google search engine -#}
<link rel="canonical" href="{{ config.url }}/{{ page.canonical_path.replace('index.html', '') }}"/>

{#- Fancybox styling -#}
{%- if theme.fancybox -%}
  <link rel="stylesheet" type="text/css" href="{{ url_for('lib/fancybox/jquery.fancybox.css') }}" />
{%- endif -%}

{#- Nprogress styling -#}
{%- if theme.pjax -%}
  <link rel="stylesheet" type="text/css" href="{{ url_for('lib/nprogress/nprogress.min.css') }}" />
{%- endif -%}

{#- MathJax (LaTeX) support -#}
{%- if theme.latex -%}
  <script type="text/x-mathjax-config">
    MathJax.Hub.Config({ tex2jax: { inlineMath: [['$','$'], ['\\(','\\)']] } });
  </script>
  <script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML"></script>
{%- endif -%}
<script>
  var remark_config = {
    host: 'https://www.winn.cc/remark',
    site_id: 'winn_blog',
    locale: 'zh'
  }
</script>
<script>!function(e,n){for(var o=0;o<e.length;o++){var r=n.createElement("script"),c=".js",d=n.head||n.body;"noModule"in r?(r.type="module",c=".mjs"):r.async=!0,r.defer=!0,r.src=remark_config.host+"/web/"+e[o]+c,d.appendChild(r)}}(remark_config.components||["embed"],document);
</script>
{#- Theme styling -#}
<link rel="stylesheet" type="text/css" href="{{ url_for('css/style.css') }}?v={{ theme.version }}" />

{%- set themeConfig = { leancloud: theme.leancloud, toc: theme.toc, fancybox: theme.fancybox, pjax: theme.pjax, latex: theme.latex } -%}
<script>
  window.config = {{ JSON.stringify(themeConfig) }};
</script>
