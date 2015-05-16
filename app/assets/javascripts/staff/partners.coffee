$('.customer-row').hover(
  (ev) -> $(this).addClass 'active'
  (ev) -> $(this).removeClass 'active'
)