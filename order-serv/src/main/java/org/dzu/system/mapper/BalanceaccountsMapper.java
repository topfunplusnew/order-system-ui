package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.Balanceaccounts;

/**
 * 平账Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface BalanceaccountsMapper extends BaseMapper<Balanceaccounts>
{
    /**
     * 查询平账
     * 
     * @param id 平账主键
     * @return 平账
     */
    public Balanceaccounts selectBalanceaccountsById(Long id);

    /**
     * 查询平账列表
     * 
     * @param balanceaccounts 平账
     * @return 平账集合
     */
    public List<Balanceaccounts> selectBalanceaccountsList(Balanceaccounts balanceaccounts);

    /**
     * 新增平账
     * 
     * @param balanceaccounts 平账
     * @return 结果
     */
    public int insertBalanceaccounts(Balanceaccounts balanceaccounts);

    /**
     * 修改平账
     * 
     * @param balanceaccounts 平账
     * @return 结果
     */
    public int updateBalanceaccounts(Balanceaccounts balanceaccounts);

    /**
     * 删除平账
     * 
     * @param id 平账主键
     * @return 结果
     */
    public int deleteBalanceaccountsById(Long id);

    /**
     * 批量删除平账
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBalanceaccountsByIds(Long[] ids);
}
