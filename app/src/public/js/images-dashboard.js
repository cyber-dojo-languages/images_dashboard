
window.reload = (id,org) => {

  $(id + ' tr[name]').each(function() {
    const tr = $(this);
    const repo = tr.attr('name');
    $.ajax({
      url: '/build?org='+org+'&repo='+repo,
      success: (build) => {
        $('td span.state', tr).html(coloured_state(build.state));
        $('td span.age',   tr).html(coloured_age(build.age));
        $('td span.took',  tr).html(build.took);
      }
    });
  });

  const coloured_state = (value) => {
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

  const coloured_age = (value) => {
    let colour = '';
    if (value.includes('Day') || value.includes('Week') || value.includes('Month'))
      colour = 'red';
    else
      colour = 'black';
    return '<span style="color:'+colour+';">'+value+'</span>';
  };

};
