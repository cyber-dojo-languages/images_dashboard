
window.reload = function(id,org) {

  $(id + 'tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $('td span.state', tr).html('');
    $('td span.age',   tr).html('');
    $('td span.took',  tr).html('');
  });

  const html_state = (value) => {
    let colour = '';
    switch (value) {
      case 'failed':
        colour = 'red'; break;
      case 'passed':
        colour = 'green'; break;
      default:
        colour = 'black'; break;
    }
    return '<span style="color:'+colour+';">'+value+'</span>';
  };

  $(id + ' tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $.ajax({
      url: '/build?org='+org+'&repo='+repo,
      success: function(build) {
        $('td span.state', tr).html(html_state(build.state));
        $('td span.age',   tr).html(build.age);
        $('td span.took',  tr).html(build.took);
      }
    });
  });
};
