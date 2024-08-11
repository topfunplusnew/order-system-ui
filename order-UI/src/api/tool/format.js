export const formatTime = (date) => {
  return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`
}

export const fix = (value) => {
  return Number(value).toFixed(2)
}
