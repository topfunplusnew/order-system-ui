package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.OilCard;
import org.dzu.system.domain.OilCardConsume;
import org.dzu.system.mapper.OilCardConsumeMapper;
import org.dzu.system.mapper.OilCardMapper;
import org.dzu.system.service.IOilCardConsumeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 加油卡消费信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OilCardConsumeServiceImpl implements IOilCardConsumeService
{
    @Autowired
    private OilCardConsumeMapper oilCardConsumeMapper;
    @Autowired
    private OilCardMapper oilCardMapper;
    /**
     * 查询加油卡消费信息
     *
     * @param id 加油卡消费信息主键
     * @return 加油卡消费信息
     */
    @Override
    public OilCardConsume selectOilCardConsumeById(Long id)
    {
        return oilCardConsumeMapper.selectOilCardConsumeById(id);
    }

    /**
     * 查询加油卡消费信息列表
     *
     * @param oilCardConsume 加油卡消费信息
     * @return 加油卡消费信息
     */
    @Override
    public List<OilCardConsume> selectOilCardConsumeList(OilCardConsume oilCardConsume)
    {
        return oilCardConsumeMapper.selectOilCardConsumeList(oilCardConsume);
    }

    @Transactional // 表示此方法需要事务管理
    public boolean saveOilCardConsume(OilCardConsume oilCardConsume) {
        // 检查加油金额是否正确
        if (!validateRefuelingMoney(oilCardConsume)) {
            throw new IllegalArgumentException("加油金额不正确，加油金额应等于加油量乘以单价");
        }

        // 保存加油卡消费信息
        return oilCardConsumeMapper.insertOilCardConsume(oilCardConsume) > 0;
    }

    /**
     * 校验加油金额是否正确
     *
     * @param oilCardConsume 加油卡消费信息对象
     * @return 校验结果，正确返回 true，否则返回 false
     */
    private boolean validateRefuelingMoney(OilCardConsume oilCardConsume) {
        String refuelingNumber = oilCardConsume.getRefuelingNumber();
        String unitPrice = oilCardConsume.getUnitPrice();
        String refuelingMoney = oilCardConsume.getRefuelingMoney();

        if (refuelingNumber != null && unitPrice != null && refuelingMoney != null) {
            try {
                // 将字符串转换为 double 类型
                double refuelingNum = Double.parseDouble(refuelingNumber);
                double unitPrc = Double.parseDouble(unitPrice);
                double refuelMoney = Double.parseDouble(refuelingMoney);

                // 校验加油金额是否等于加油量乘以单价
                return Math.abs(refuelMoney - (refuelingNum * unitPrc)) < 0.01;
            } catch (NumberFormatException e) {
                // 如果转换失败，表示输入数据有误
                return false;
            }
        }

        // 如果任何一个值为空，则表示数据不完整，校验失败
        return false;
    }
    /**
     * 新增加油卡消费信息
     *
     * @param oilCardConsume 加油卡消费信息
     * @return 结果
     */
    @Override
    public int insertOilCardConsume(OilCardConsume oilCardConsume)
    {
        saveOilCardConsume(oilCardConsume);
        validateRefuelingMoney(oilCardConsume);
        oilCardConsume.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilCardConsume.setUserId(SecurityUtils.getUserId());
        oilCardConsume.setUserName(SecurityUtils.getUserTruename());
        oilCardConsume.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return oilCardConsumeMapper.insertOilCardConsume(oilCardConsume);
    }


    /**
     * 修改加油卡消费信息
     *
     * @param oilCardConsume 加油卡消费信息
     * @return 结果
     */
    @Override
    public int updateOilCardConsume(OilCardConsume oilCardConsume)
    {
        saveOilCardConsume(oilCardConsume);
        validateRefuelingMoney(oilCardConsume);
        // 更新油卡余额
        String oilCardNo = oilCardConsume.getOilCardNo();
        // 获取油卡的当前余额
        OilCard oilCard = oilCardMapper.selectOilCardById(oilCardConsume.getId());
        oilCardConsume.setUserId(SecurityUtils.getUserId());
        oilCardConsume.setUserName(SecurityUtils.getUserTruename());
        oilCardConsume.setUpdateTime(DateUtils.getNowDate());
        return oilCardConsumeMapper.updateOilCardConsume(oilCardConsume);
    }

    /**
     * 批量删除加油卡消费信息
     *
     * @param ids 需要删除的加油卡消费信息主键
     * @return 结果
     */
    @Override
    public int deleteOilCardConsumeByIds(Long[] ids)
    {
        return oilCardConsumeMapper.deleteOilCardConsumeByIds(ids);
    }

    /**
     * 删除加油卡消费信息信息
     *
     * @param id 加油卡消费信息主键
     * @return 结果
     */
    @Override
    public int deleteOilCardConsumeById(Long id)
    {
        return oilCardConsumeMapper.deleteOilCardConsumeById(id);
    }
}
