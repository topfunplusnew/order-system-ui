package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.RecoverMoney;

/**
 * 借出款收回信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface RecoverMoneyMapper extends BaseMapper<RecoverMoney>
{
    /**
     * 查询借出款收回信息
     * 
     * @param id 借出款收回信息主键
     * @return 借出款收回信息
     */
    public RecoverMoney selectRecoverMoneyById(Long id);

    /**
     * 查询借出款收回信息列表
     * 
     * @param recoverMoney 借出款收回信息
     * @return 借出款收回信息集合
     */
    public List<RecoverMoney> selectRecoverMoneyList(RecoverMoney recoverMoney);

    /**
     * 新增借出款收回信息
     * 
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    public int insertRecoverMoney(RecoverMoney recoverMoney);

    /**
     * 修改借出款收回信息
     * 
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    public int updateRecoverMoney(RecoverMoney recoverMoney);

    /**
     * 删除借出款收回信息
     * 
     * @param id 借出款收回信息主键
     * @return 结果
     */
    public int deleteRecoverMoneyById(Long id);

    /**
     * 批量删除借出款收回信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteRecoverMoneyByIds(Long[] ids);
}
