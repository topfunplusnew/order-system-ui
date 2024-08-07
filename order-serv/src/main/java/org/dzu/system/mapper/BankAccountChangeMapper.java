package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.BankAccountChange;

import java.util.List;

/**
 * 银行账号变动流水Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface BankAccountChangeMapper extends BaseMapper<BankAccountChange>
{
    /**
     * 查询银行账号变动流水
     * 
     * @param id 银行账号变动流水主键
     * @return 银行账号变动流水
     */
    public BankAccountChange selectBankAccountChangeById(Long id);

    /**
     * 查询银行账号变动流水列表
     * 
     * @param bankAccountChange 银行账号变动流水
     * @return 银行账号变动流水集合
     */
    public List<BankAccountChange> selectBankAccountChangeList(BankAccountChange bankAccountChange);

    /**
     * 新增银行账号变动流水
     * 
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    public int insertBankAccountChange(BankAccountChange bankAccountChange);

    /**
     * 修改银行账号变动流水
     * 
     * @param bankAccountChange 银行账号变动流水
     * @return 结果
     */
    public int updateBankAccountChange(BankAccountChange bankAccountChange);

    /**
     * 删除银行账号变动流水
     * 
     * @param id 银行账号变动流水主键
     * @return 结果
     */
    public int deleteBankAccountChangeById(Long id);

    /**
     * 批量删除银行账号变动流水
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankAccountChangeByIds(Long[] ids);

    /**
     * 根据UUID更新流水
     * @param bankAccountChange
     * @return
     */
    public int updateBankAccountChangeByUUID(BankAccountChange bankAccountChange);

    /**
     * 根据UUID删除流水
     * @param uuids
     * @return
     */
    public int deleteBankAccountChangeByUUIDS(String[] uuids);
}
