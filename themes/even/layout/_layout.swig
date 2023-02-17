<!DOCTYPE html>
<html lang="{{ config.language }}">
  <head>
  <script>
  var _hmt = _hmt || [];
  (function() {
    var hm = document.createElement("script");
    hm.src = "https://hm.baidu.com/hm.js?46dc9ceed870eaf1f7b89f98259df601";
    var s = document.getElementsByTagName("script")[0]; 
    s.parentNode.insertBefore(hm, s);
  })();
  </script>
    {%- include '_partial/head.swig' %}
    <title>{%- block title -%}{%- endblock -%}</title>
  </head>

  <body>
    {%- include '_partial/slideout.swig' -%}
    <div class="container" id="mobile-panel">
      <header id="header" class="header">
        {%- include '_partial/header.swig' -%}
      </header>

      <main id="main" class="main">
        <div class="content-wrapper">
          <div id="content" class="content">
            {%- block content -%}{%- endblock -%}
          </div>
          {#
          {%- include '_partial/comments.swig' -%}
          #}
        </div>
      </main>

      <footer id="footer" class="footer">
        {%- include '_partial/footer.swig' -%}
      </footer>

      <div class="back-to-top" id="back-to-top">
        <i class="iconfont icon-up"></i>
      </div>
    </div>
{#
    {%- include '_script/comments.swig' -%}
#}
    {%- include '_script/libs.swig' -%}
    {%- include '_script/theme.swig' -%}
  </body>
</html>
