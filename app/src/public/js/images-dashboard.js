
window.reload = function(id,org) {
  const space = ' ';
  $(id + space + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $('td span.status', tr).html('');
    $('td span.time',   tr).html('');
    $('td span.date',   tr).html('');
  });

  $(id + space + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $.ajax({
      url: '/build?org='+org+'&repo='+repo,
      success: function(build) {
        if (build.status === 'failed') {
          build.status = '<span style="color:red;">failed</span>'
        }
        if (build.status === 'passed') {
          build.status = '<span style="color:green;">passed</span>'
        }
        $('td span.status', tr).html(build.status);
        $('td span.time',   tr).html(build.time);
        $('td span.date',   tr).html(build.date);
      }
    });
  });
};
