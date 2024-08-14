export const formatTime = (date) => {
  return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`
}

export const fix = (value) => {
  return Number(value).toFixed(2)
}

//金钱转大写
export function numToChineseUppercase(n) {
  //零元特殊处理
  if (n === 0) {
    return '零元整';
  }
  const units = ['', '拾', '佰', '仟'];
  const sections = ['', '万', '亿', '万亿'];
  const numbers = '零壹贰叁肆伍陆柒捌玖';

  let numStr = String(n);
  let numLen = numStr.length;
  let result = [];

  function sectionToChinese(sectionNum) {
    let sectionResult = '';
    let zero = false;
    let unitPos = 0;

    for (let i = sectionNum.length - 1; i >= 0; i--) {
      let num = parseInt(sectionNum[i]);
      if (num === 0) {
        if (!zero) {
          zero = true;
          sectionResult = numbers[0] + sectionResult;
        }
      } else {
        zero = false;
        sectionResult = numbers[num] + units[unitPos] + sectionResult;
      }
      unitPos++;
    }
    return sectionResult.replace(/零+$/, '');
  }

  let secIndex = 0;
  while (numLen > 0) {
    let start = Math.max(0, numLen - 4);
    let sectionNum = numStr.substring(start, numLen);
    let sectionResult = sectionToChinese(sectionNum);
    if (sectionResult) {
      result.unshift(sections[secIndex]);
      result.unshift(sectionResult);
    }
    numLen -= 4;
    secIndex++;
  }

  let chineseNumber = result.join('').replace(/零(万|亿|$)/g, '$1').replace(/亿万/, '亿零');
  if (chineseNumber.endsWith('零')) {
    chineseNumber = chineseNumber.slice(0, -1);
  }

  return chineseNumber + '元整';
}
