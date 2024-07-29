package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Oilcardmain;

/**
 * 基础信息-加油卡主卡登记Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IOilcardmainService 
{
    /**
     * 查询基础信息-加油卡主卡登记
     * 
     * @param id 基础信息-加油卡主卡登记主键
     * @return 基础信息-加油卡主卡登记
     */
    public Oilcardmain selectOilcardmainById(Long id);

    /**
     * 查询基础信息-加油卡主卡登记列表
     * 
     * @param oilcardmain 基础信息-加油卡主卡登记
     * @return 基础信息-加油卡主卡登记集合
     */
    public List<Oilcardmain> selectOilcardmainList(Oilcardmain oilcardmain);

    /**
     * 新增基础信息-加油卡主卡登记
     * 
     * @param oilcardmain 基础信息-加油卡主卡登记
     * @return 结果
     */
    public int insertOilcardmain(Oilcardmain oilcardmain);

    /**
     * 修改基础信息-加油卡主卡登记
     * 
     * @param oilcardmain 基础信息-加油卡主卡登记
     * @return 结果
     */
    public int updateOilcardmain(Oilcardmain oilcardmain);

    /**
     * 批量删除基础信息-加油卡主卡登记
     * 
     * @param ids 需要删除的基础信息-加油卡主卡登记主键集合
     * @return 结果
     */
    public int deleteOilcardmainByIds(Long[] ids);

    /**
     * 删除基础信息-加油卡主卡登记信息
     * 
     * @param id 基础信息-加油卡主卡登记主键
     * @return 结果
     */
    public int deleteOilcardmainById(Long id);
}
