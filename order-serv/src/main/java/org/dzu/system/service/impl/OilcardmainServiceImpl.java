package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.OilcardmainMapper;
import org.dzu.system.domain.Oilcardmain;
import org.dzu.system.service.IOilcardmainService;

/**
 * 基础信息-加油卡主卡登记Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class OilcardmainServiceImpl implements IOilcardmainService 
{
    @Autowired
    private OilcardmainMapper oilcardmainMapper;

    /**
     * 查询基础信息-加油卡主卡登记
     * 
     * @param id 基础信息-加油卡主卡登记主键
     * @return 基础信息-加油卡主卡登记
     */
    @Override
    public Oilcardmain selectOilcardmainById(Long id)
    {
        return oilcardmainMapper.selectOilcardmainById(id);
    }

    /**
     * 查询基础信息-加油卡主卡登记列表
     * 
     * @param oilcardmain 基础信息-加油卡主卡登记
     * @return 基础信息-加油卡主卡登记
     */
    @Override
    public List<Oilcardmain> selectOilcardmainList(Oilcardmain oilcardmain)
    {
        return oilcardmainMapper.selectOilcardmainList(oilcardmain);
    }

    /**
     * 新增基础信息-加油卡主卡登记
     * 
     * @param oilcardmain 基础信息-加油卡主卡登记
     * @return 结果
     */
    @Override
    public int insertOilcardmain(Oilcardmain oilcardmain)
    {
        return oilcardmainMapper.insertOilcardmain(oilcardmain);
    }

    /**
     * 修改基础信息-加油卡主卡登记
     * 
     * @param oilcardmain 基础信息-加油卡主卡登记
     * @return 结果
     */
    @Override
    public int updateOilcardmain(Oilcardmain oilcardmain)
    {
        oilcardmain.setUpdateTime(DateUtils.getNowDate());
        return oilcardmainMapper.updateOilcardmain(oilcardmain);
    }

    /**
     * 批量删除基础信息-加油卡主卡登记
     * 
     * @param ids 需要删除的基础信息-加油卡主卡登记主键
     * @return 结果
     */
    @Override
    public int deleteOilcardmainByIds(Long[] ids)
    {
        return oilcardmainMapper.deleteOilcardmainByIds(ids);
    }

    /**
     * 删除基础信息-加油卡主卡登记信息
     * 
     * @param id 基础信息-加油卡主卡登记主键
     * @return 结果
     */
    @Override
    public int deleteOilcardmainById(Long id)
    {
        return oilcardmainMapper.deleteOilcardmainById(id);
    }
}
