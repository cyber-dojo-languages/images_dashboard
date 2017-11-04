
window.reload = function(id,org) {
  const space = ' ';
  $(id + space + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $('td span.status', tr).html('');
    $('td span.ago',    tr).html('');
    $('td span.took',   tr).html('');
  });

  $(id + space + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $.ajax({
      url: '/build?org='+org+'&repo='+repo,
      success: function(build) {
        if (build.status === 'failed') {
          build.status = '<span style="color:red;">failed</span>';
        }
        else if (build.status === 'passed') {
          build.status = '<span style="color:green;">passed</span>';
        }
        else {
          build.status = '<span style="color:black;">:' + build.status + ':</span>';
        }
        $('td span.status', tr).html(build.status);
        $('td span.ago',    tr).html(build.ago);
        $('td span.took',   tr).html(build.took);
      }
    });
  });
};
