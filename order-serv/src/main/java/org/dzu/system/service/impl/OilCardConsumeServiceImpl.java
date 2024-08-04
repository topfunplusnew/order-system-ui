package org.dzu.system.service.impl;

import java.util.List;

import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.OilCard;
import org.dzu.system.mapper.OilCardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OilCardConsumeMapper;
import org.dzu.system.domain.OilCardConsume;
import org.dzu.system.service.IOilCardConsumeService;

import org.dzu.common.constant.DelConstants;
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

    /**
     * 新增加油卡消费信息
     *
     * @param oilCardConsume 加油卡消费信息
     * @return 结果
     */
    @Override
    public int insertOilCardConsume(OilCardConsume oilCardConsume)
    {
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

        // 更新油卡余额
        String oilCardNo = oilCardConsume.getOilCardNo();
        // 获取油卡的当前余额
        OilCard oilCard = oilCardMapper.selectOilCardById(oilCardConsume.getId() );
        if (oilCard == null) {
            throw new ServiceException("油卡信息不存在");
        }
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
