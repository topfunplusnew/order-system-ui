package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.dzu.system.domain.BankAccount;

import java.util.List;

/**
 * 银行账号Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface BankAccountMapper extends BaseMapper<BankAccount>
{
    /**
     * 查询银行账号
     * 
     * @param id 银行账号主键
     * @return 银行账号
     */
    public BankAccount selectBankAccountById(Long id);

    /**
     * 查询银行账号列表
     * 
     * @param bankAccount 银行账号
     * @return 银行账号集合
     */
    public List<BankAccount> selectBankAccountList(BankAccount bankAccount);

    /**
     * 新增银行账号
     * 
     * @param bankAccount 银行账号
     * @return 结果
     */
    public int insertBankAccount(BankAccount bankAccount);

    /**
     * 修改银行账号
     * 
     * @param bankAccount 银行账号
     * @return 结果
     */
    public int updateBankAccount(BankAccount bankAccount);

    /**
     * 删除银行账号
     * 
     * @param id 银行账号主键
     * @return 结果
     */
    public int deleteBankAccountById(Long id);

    /**
     * 批量删除银行账号
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBankAccountByIds(Long[] ids);

    /**
     * 根据银行卡号返回
     * @param bankNo
     * @return
     */
    public  BankAccount selectBankAccountByBankNo( @Param("bankNo") String bankNo);
}