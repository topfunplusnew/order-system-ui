package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Oilcardmain;

/**
 * 加油卡主卡登记信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface OilcardmainMapper 
{
    /**
     * 查询加油卡主卡登记信息
     * 
     * @param id 加油卡主卡登记信息主键
     * @return 加油卡主卡登记信息
     */
    public Oilcardmain selectOilcardmainById(Long id);

    /**
     * 查询加油卡主卡登记信息列表
     * 
     * @param oilcardmain 加油卡主卡登记信息
     * @return 加油卡主卡登记信息集合
     */
    public List<Oilcardmain> selectOilcardmainList(Oilcardmain oilcardmain);

    /**
     * 新增加油卡主卡登记信息
     * 
     * @param oilcardmain 加油卡主卡登记信息
     * @return 结果
     */
    public int insertOilcardmain(Oilcardmain oilcardmain);

    /**
     * 修改加油卡主卡登记信息
     * 
     * @param oilcardmain 加油卡主卡登记信息
     * @return 结果
     */
    public int updateOilcardmain(Oilcardmain oilcardmain);

    /**
     * 删除加油卡主卡登记信息
     * 
     * @param id 加油卡主卡登记信息主键
     * @return 结果
     */
    public int deleteOilcardmainById(Long id);

    /**
     * 批量删除加油卡主卡登记信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOilcardmainByIds(Long[] ids);
}
