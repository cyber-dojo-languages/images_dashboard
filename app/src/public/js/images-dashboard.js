
window.reload = function(id) {
  const space = ' ';
  $(id + space + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $.ajax({
      url: '/build?repo='+repo,
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
