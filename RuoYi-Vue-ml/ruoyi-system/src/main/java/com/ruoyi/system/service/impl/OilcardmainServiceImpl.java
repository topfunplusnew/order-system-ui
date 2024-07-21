package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.OilcardmainMapper;
import com.ruoyi.system.domain.Oilcardmain;
import com.ruoyi.system.service.IOilcardmainService;

/**
 * 加油卡主卡登记信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class OilcardmainServiceImpl implements IOilcardmainService 
{
    @Autowired
    private OilcardmainMapper oilcardmainMapper;

    /**
     * 查询加油卡主卡登记信息
     * 
     * @param id 加油卡主卡登记信息主键
     * @return 加油卡主卡登记信息
     */
    @Override
    public Oilcardmain selectOilcardmainById(Long id)
    {
        return oilcardmainMapper.selectOilcardmainById(id);
    }

    /**
     * 查询加油卡主卡登记信息列表
     * 
     * @param oilcardmain 加油卡主卡登记信息
     * @return 加油卡主卡登记信息
     */
    @Override
    public List<Oilcardmain> selectOilcardmainList(Oilcardmain oilcardmain)
    {
        return oilcardmainMapper.selectOilcardmainList(oilcardmain);
    }

    /**
     * 新增加油卡主卡登记信息
     * 
     * @param oilcardmain 加油卡主卡登记信息
     * @return 结果
     */
    @Override
    public int insertOilcardmain(Oilcardmain oilcardmain)
    {
        return oilcardmainMapper.insertOilcardmain(oilcardmain);
    }

    /**
     * 修改加油卡主卡登记信息
     * 
     * @param oilcardmain 加油卡主卡登记信息
     * @return 结果
     */
    @Override
    public int updateOilcardmain(Oilcardmain oilcardmain)
    {
        oilcardmain.setUpdateTime(DateUtils.getNowDate());
        return oilcardmainMapper.updateOilcardmain(oilcardmain);
    }

    /**
     * 批量删除加油卡主卡登记信息
     * 
     * @param ids 需要删除的加油卡主卡登记信息主键
     * @return 结果
     */
    @Override
    public int deleteOilcardmainByIds(Long[] ids)
    {
        return oilcardmainMapper.deleteOilcardmainByIds(ids);
    }

    /**
     * 删除加油卡主卡登记信息信息
     * 
     * @param id 加油卡主卡登记信息主键
     * @return 结果
     */
    @Override
    public int deleteOilcardmainById(Long id)
    {
        return oilcardmainMapper.deleteOilcardmainById(id);
    }
}
