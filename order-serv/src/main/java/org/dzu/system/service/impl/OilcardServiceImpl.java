package org.dzu.system.service.impl;

import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Oilcard;
import org.dzu.system.mapper.OilcardMapper;
import org.dzu.system.service.IOilcardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 加油卡信息Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class OilcardServiceImpl implements IOilcardService 
{
    @Autowired
    private OilcardMapper oilcardMapper;

    /**
     * 查询加油卡信息
     * 
     * @param id 加油卡信息主键
     * @return 加油卡信息
     */
    @Override
    public Oilcard selectOilcardById(Long id)
    {
        return oilcardMapper.selectOilcardById(id);
    }

    /**
     * 查询加油卡信息列表
     * 
     * @param oilcard 加油卡信息
     * @return 加油卡信息
     */
    @Override
    public List<Oilcard> selectOilcardList(Oilcard oilcard)
    {
        return oilcardMapper.selectOilcardList(oilcard);
    }

    /**
     * 新增加油卡信息
     * 
     * @param oilcard 加油卡信息
     * @return 结果
     */
    @Override
    public int insertOilcard(Oilcard oilcard)
    {
        return oilcardMapper.insertOilcard(oilcard);
    }

    /**
     * 修改加油卡信息
     * 
     * @param oilcard 加油卡信息
     * @return 结果
     */
    @Override
    public int updateOilcard(Oilcard oilcard)
    {
        oilcard.setUpdateTime(DateUtils.getNowDate());
        return oilcardMapper.updateOilcard(oilcard);
    }

    /**
     * 批量删除加油卡信息
     * 
     * @param ids 需要删除的加油卡信息主键
     * @return 结果
     */
    @Override
    public int deleteOilcardByIds(Long[] ids)
    {
        return oilcardMapper.deleteOilcardByIds(ids);
    }

    /**
     * 删除加油卡信息信息
     * 
     * @param id 加油卡信息主键
     * @return 结果
     */
    @Override
    public int deleteOilcardById(Long id)
    {
        return oilcardMapper.deleteOilcardById(id);
    }
}
