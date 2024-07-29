package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OilcardMapper;
import org.dzu.system.domain.Oilcard;
import org.dzu.system.service.IOilcardService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 加油卡Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OilcardServiceImpl implements IOilcardService
{
    @Autowired
    private OilcardMapper oilcardMapper;

    /**
     * 查询加油卡
     *
     * @param id 加油卡主键
     * @return 加油卡
     */
    @Override
    public Oilcard selectOilcardById(Long id)
    {
        return oilcardMapper.selectOilcardById(id);
    }

    /**
     * 查询加油卡列表
     *
     * @param oilcard 加油卡
     * @return 加油卡
     */
    @Override
    public List<Oilcard> selectOilcardList(Oilcard oilcard)
    {
        return oilcardMapper.selectOilcardList(oilcard);
    }

    /**
     * 新增加油卡
     *
     * @param oilcard 加油卡
     * @return 结果
     */
    @Override
    public int insertOilcard(Oilcard oilcard)
    {
        oilcard.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilcard.setUserId(SecurityUtils.getUserId());
        oilcard.setUserName(SecurityUtils.getUserTruename());
        oilcard.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return oilcardMapper.insertOilcard(oilcard);
    }

    /**
     * 修改加油卡
     * 
     * @param oilcard 加油卡
     * @return 结果
     */
    @Override
    public int updateOilcard(Oilcard oilcard)
    {
        oilcard.setUserId(SecurityUtils.getUserId());
        oilcard.setUserName(SecurityUtils.getUserTruename());
        oilcard.setUpdateTime(DateUtils.getNowDate());
        return oilcardMapper.updateOilcard(oilcard);
    }

    /**
     * 批量删除加油卡
     * 
     * @param ids 需要删除的加油卡主键
     * @return 结果
     */
    @Override
    public int deleteOilcardByIds(Long[] ids)
    {
        return oilcardMapper.deleteOilcardByIds(ids);
    }

    /**
     * 删除加油卡信息
     * 
     * @param id 加油卡主键
     * @return 结果
     */
    @Override
    public int deleteOilcardById(Long id)
    {
        return oilcardMapper.deleteOilcardById(id);
    }
}
