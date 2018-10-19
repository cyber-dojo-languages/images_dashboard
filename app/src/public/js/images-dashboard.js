
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
    switch (value) {
      case 'failed':
        return coloured('red',value);
      case 'passed':
        return coloured('green',value);
      default:
        return coloured('black', value);
    }
  };

  const coloured_age = (value) => {
    if (value.includes('Day') || value.includes('Week') || value.includes('Month'))
      return coloured('red',value);
    else
      return coloured('black', value);
  };

  const coloured = (colour, value) => {
    return '<span style="color:'+colour+';">'+value+'</span>';
  };
};
