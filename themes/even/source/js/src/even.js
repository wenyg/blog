(function (window) {
  'use strict';

  function Even(config) {
    this.config = config;
  }

  Even.prototype.setup = function () {
    var leancloud = this.config.leancloud;

    this.navbar();
    this.responsiveTable();

    if (this.config.toc) {
      this.scrollToc();
      this.tocFollow();
    }
    if (this.config.fancybox) {
      this.fancybox();
    }
    if (leancloud.app_id && leancloud.app_key) {
      this.recordReadings();
    }
    if (this.config.pjax) {
      this.pjax();
    }
    if (this.config.latex) {
      this.renderLaTeX();
    }

    // 在加载评论之前检查是否存在评论根节点
    var commentRootNode = document.getElementById('remark42'); // 替换成你的评论根节点的id
    if (commentRootNode) {
      this.loadComments(); // 如果存在评论根节点，则加载评论
    }

    window.addEventListener('beforeunload', function () {
      even.destroyComments();
    });

    this.backToTop();
  };


  // 在Even.prototype中添加销毁评论节点的方法
  Even.prototype.destroyComments = function () {
    var commentRootNode = document.getElementById('remark42'); // 替换成你的评论根节点的id
    if (commentRootNode) {
      commentRootNode.innerHTML = ''; // 清空评论节点的内容
      // 如果有其他需要清理的操作，可以在这里添加
    }
  };

  // 新增加载评论的函数
  Even.prototype.loadComments = function () {

    // 动态设置 remark_config 对象中的 url 属性
    window.remark_config.url = window.location.href;

    var components = ['embed'];
    for (var i = 0; i < components.length; i++) {
      var d = document, s = d.createElement('script');
      s.src = remark_config.host + '/web/' + components[i] + '.js';
      s.defer = true;
      (d.head || d.body).appendChild(s);
    }
  };

  Even.prototype.navbar = function () {
    var $nav = $('#mobile-navbar');
    var $navIcon = $('.mobile-navbar-icon');

    var slideout = new Slideout({
      'panel': document.getElementById('mobile-panel'),
      'menu': document.getElementById('mobile-menu'),
      'padding': 180,
      'tolerance': 70
    });
    slideout.disableTouch();

    $navIcon.click(function () {
      slideout.toggle();
    });

    slideout.on('beforeopen', function () {
      $nav.addClass('fixed-open');
      $navIcon.addClass('icon-click').removeClass('icon-out');
    });

    slideout.on('beforeclose', function () {
      $nav.removeClass('fixed-open');
      $navIcon.addClass('icon-out').removeClass('icon-click');
    });

    $('#mobile-panel').on('touchend', function () {
      slideout.isOpen() && $navIcon.click();
    });
  };

  Even.prototype.responsiveTable = function () {
    var tables = $('.post-content > table')
    tables.wrap('<div class="table-responsive">')
  };

  Even.prototype.scrollToc = function () {
    var SPACING = 20;
    var $toc = $('.post-toc');
    var $footer = $('.post-footer');

    if ($toc.length) {
      var minScrollTop = $toc.offset().top - SPACING;
      var maxScrollTop = $footer.offset().top - $toc.height() - SPACING;

      var tocState = {
        start: {
          'position': 'absolute',
          'top': minScrollTop
        },
        process: {
          'position': 'fixed',
          'top': SPACING
        },
        end: {
          'position': 'absolute',
          'top': maxScrollTop
        }
      }

      $(window).scroll(function () {
        var scrollTop = $(window).scrollTop();

        if (scrollTop < minScrollTop) {
          $toc.css(tocState.start);
        } else if (scrollTop > maxScrollTop) {
          $toc.css(tocState.end);
        } else {
          $toc.css(tocState.process);
        }
      })
    }
  };

  Even.prototype.tocFollow = function () {
    var HEADERFIX = 30;
    var $toclink = $('.toc-link'),
      $headerlink = $('.headerlink');

    $(window).scroll(function () {
      var headerlinkTop = $.map($headerlink, function (link) {
        return $(link).offset().top;
      });
      var scrollTop = $(window).scrollTop();

      for (var i = 0; i < $toclink.length; i++) {
        var isLastOne = i + 1 === $toclink.length,
          currentTop = headerlinkTop[i] - HEADERFIX,
          nextTop = isLastOne ? Infinity : headerlinkTop[i + 1] - HEADERFIX;

        if (currentTop < scrollTop && scrollTop <= nextTop) {
          $($toclink[i]).addClass('active');
        } else {
          $($toclink[i]).removeClass('active');
        }
      }
    });
  };

  Even.prototype.fancybox = function () {
    if ($.fancybox) {
      $('.post').each(function () {
        $(this).find('img').each(function () {
          var href = 'href="' + this.src + '"';
          var title = 'title="' + this.alt + '"';
          $(this).wrap('<a class="fancybox" ' + href + ' ' + title + '></a>');
        });
      });

      $('.fancybox').fancybox({
        openEffect: 'elastic',
        closeEffect: 'elastic'
      });
    }
  };

  Even.prototype.recordReadings = function () {
    if (typeof AV !== 'object') return;

    var $visits = $('.post-visits');
    var Counter = AV.Object.extend('Counter');
    if ($visits.length === 1) {
      addCounter(Counter);
    } else {
      showTime(Counter);
    }

    function updateVisits(dom, time) {
      var readText = dom.text().replace(/(\d+)/i, time)
      dom.text(readText);
    }

    function addCounter(Counter) {
      var query = new AV.Query(Counter);

      var url = $visits.data('url').trim();
      var title = $visits.data('title').trim();

      query.equalTo('url', url);
      query.find().then(function (results) {
        if (results.length > 0) {
          var counter = results[0];
          counter.save(null, {
            fetchWhenSave: true
          }).then(function (counter) {
            counter.increment('time', 1);
            return counter.save();
          }).then(function (counter) {
            updateVisits($visits, counter.get('time'));
          });
        } else {
          var newcounter = new Counter();
          newcounter.set('title', title);
          newcounter.set('url', url);
          newcounter.set('time', 1);

          var acl = new AV.ACL();
          acl.setWriteAccess('*', true)
          acl.setReadAccess('*', true)
          newcounter.setACL(acl)

          newcounter.save().then(function () {
            updateVisits($visits, newcounter.get('time'));
          });
        }
      }, function (error) {
        // eslint-disable-next-line
        console.log('Error:' + error.code + ' ' + error.message);
      });
    }

    function showTime(Counter) {
      $visits.each(function () {
        var $this = $(this);
        var query = new AV.Query(Counter);
        var url = $this.data('url').trim();

        query.equalTo('url', url);
        query.find().then(function (results) {
          if (results.length === 0) {
            updateVisits($this, 0);
          } else {
            var counter = results[0];
            updateVisits($this, counter.get('time'));
          }
        }, function (error) {
          // eslint-disable-next-line
          console.log('Error:' + error.code + ' ' + error.message);
        });
      })
    }
  };

  Even.prototype.pjax = function () {
    if (location.hostname === 'localhost' || this.hasPjax) return;
    this.hasPjax = true;
    this._fancybox = $.fancybox;
    this._fancyboxProto = $.prototype.fancybox;

    var that = this;
    $(document).pjax('a', 'body', { fragment: 'body' });
    $(document).on('pjax:send', function () {
      NProgress.start();
      $('body').addClass('hide-top');
    });
    $(document).on('pjax:complete', function () {
      NProgress.done();
      $('body').removeClass('hide-top');
      $.fancybox = that._fancybox;
      $.prototype.fancybox = that._fancyboxProto;
      that.setup();
    });
  };

  Even.prototype.backToTop = function () {
    var $backToTop = $('#back-to-top');

    $(window).scroll(function () {
      if ($(window).scrollTop() > 100) {
        $backToTop.fadeIn(1000);
      } else {
        $backToTop.fadeOut(1000);
      }
    });

    $backToTop.click(function () {
      $('body,html').animate({ scrollTop: 0 });
    });
  };

  Even.prototype.renderLaTeX = function () {
    var loopID = setInterval(function () {
      if (window.MathJax) {
        var jax = window.MathJax;
        jax.Hub.Config({ tex2jax: { inlineMath: [['$', '$'], ['\\(', '\\)']] } });
        jax.Hub.Queue(['Typeset', jax.Hub, $(document.body)[0]]);
        clearInterval(loopID);
      }
    }, 500);
  }

  var config = window.config;
  var even = new Even(config);
  even.setup();
}(window))
