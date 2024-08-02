package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.Payment;

/**
 * 付款信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface PaymentMapper extends BaseMapper<Payment>
{
    /**
     * 查询付款信息
     * 
     * @param id 付款信息主键
     * @return 付款信息
     */
    public Payment selectPaymentById(Long id);

    /**
     * 查询付款信息列表
     * 
     * @param payment 付款信息
     * @return 付款信息集合
     */
    public List<Payment> selectPaymentList(Payment payment);

    /**
     * 新增付款信息
     * 
     * @param payment 付款信息
     * @return 结果
     */
    public int insertPayment(Payment payment);

    /**
     * 修改付款信息
     * 
     * @param payment 付款信息
     * @return 结果
     */
    public int updatePayment(Payment payment);

    /**
     * 删除付款信息
     * 
     * @param id 付款信息主键
     * @return 结果
     */
    public int deletePaymentById(Long id);

    /**
     * 批量删除付款信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deletePaymentByIds(Long[] ids);

    void insertPaymentByApply(Long applyID);
}
