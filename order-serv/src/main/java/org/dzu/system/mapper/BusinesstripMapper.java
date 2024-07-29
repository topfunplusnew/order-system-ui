package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.Businesstrip;

/**
 * 出差登记Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface BusinesstripMapper extends BaseMapper<Businesstrip>
{
    /**
     * 查询出差登记
     * 
     * @param id 出差登记主键
     * @return 出差登记
     */
    public Businesstrip selectBusinesstripById(Long id);

    /**
     * 查询出差登记列表
     * 
     * @param businesstrip 出差登记
     * @return 出差登记集合
     */
    public List<Businesstrip> selectBusinesstripList(Businesstrip businesstrip);

    /**
     * 新增出差登记
     * 
     * @param businesstrip 出差登记
     * @return 结果
     */
    public int insertBusinesstrip(Businesstrip businesstrip);

    /**
     * 修改出差登记
     * 
     * @param businesstrip 出差登记
     * @return 结果
     */
    public int updateBusinesstrip(Businesstrip businesstrip);

    /**
     * 删除出差登记
     * 
     * @param id 出差登记主键
     * @return 结果
     */
    public int deleteBusinesstripById(Long id);

    /**
     * 批量删除出差登记
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBusinesstripByIds(Long[] ids);
}
