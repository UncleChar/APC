
#ifndef PartnerConfig_h
#define PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088511933544308"

//收款支付宝账号
#define SellerID  @"yingtehua8@sina.com"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAL0M8jaJCm9bMb7PjgI0wR9+mpzWTcNTwTyYBEXmrJg3MjRVluUezDjQhQBSrgaMTeM40cz+1Nt/f1OlS/vB9PzGSF+MDty6zS0NQEEvVjUUge7PsOtbPDIEmuPppKIj4wETfavaZt7j4/kVuABDC2P1DpPRP686dJsNTkSO5qrNAgMBAAECgYApxEVy9P3gMkagQFzAcgVEvwTLp7EQeV2U1IUFKHxzOKaX11z6C77UwoTP2HRoL/E5RSFc5+QBBn8L7NYHrgdAu4L5Kl048saM53QyXJviQs7lgxDSBbo+EHDY9OJJsVRalpqKSirgBZmce/M4/tNhDxUfV5yXvxOC43JEr92UIQJBAPXbahDDMN+D0MqG1y0zPyU5bJwopXsSLIxpqp4vRmHokMxlber5HGMgSSnVQ9x9j974G1RSamqV34xwnqPzIlUCQQDE2ZPgtKd9Te19kGpmmCs64iqlkUVabAuKI8wMyx4hGZx6/EpeufFiTpF3F3YDN37JOenBefLL9UIkrOrjXI6ZAkBmpX75FKV5DG3FwNph0r2QaxM/d3DvmzziOtOzS4WVJyYdUFO+ANerQzWIs7OrgPjqXKf8YpRvf7dfyT1SshYpAkAhj0qDw6jOVwvHHWjWZtjv6AEHSxX8zXDGM0YlZDeVww0Hdp2jOqYpcWWhXRGUiNCHs+TjREwdc4m8QPKmom/5AkAYGRw6TLB/XWfEvlGLMHMmbZWMXDBdBmlIN+JK2oRjIoTryG35KlXzAHWcAq2xVhvCd6gJjz9arUmqewOLBMWn"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"1g81z5tgu3o2yst4mqm6n838dxe5cw1a"

#endif



/*
 
 // 支付信息配置文件
 #import "PartnerConfig.h"
 
 // 数据签名文件
 #import "DataSigner.h"
 
 // 订单
 #import "Order.h"
 // 支付sdk
 #import <AlipaySDK/AlipaySDK.h>
 
 //    self.view.backgroundColor = [UIColor purpleColor];
 //    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 40)];
 //    [btn setTitle:@"支付·" forState:UIControlStateNormal];
 //    [self.view addSubview:btn];
 //    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
 // Do any additional setup after loading the view.
 
 
 //- (void)btnClicked {
 //    NSString *partner = PartnerID; //支付宝分配给商户的ID
 //    NSString *seller = SellerID; //收款支付宝账号（用于收💰）
 //    NSString *privateKey = PartnerPrivKey; //商户私钥
 //
 //    /*
 //     * 生成订单信息及签名
 //     */
//    //将商品信息赋予Order的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner; //商户ID
//    order.seller = seller; //收款支付宝账号
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.productName = @"香蕉"; //商品标题
//    order.productDescription = @"5斤香蕉"; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格(重要)
//    order.notifyURL =  @"http://www.xxx.com"; //回调URL（通知服务器端交易结果）(重要)
//    // 1777297988
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//
//    // 应用注册scheme, 在AlipayDEMO-Info.plist定义URL types
//    NSString *appScheme = @"alisdkdemo";
//
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey); //通过私钥创建签名
//    NSString *signedString = [signer signString:orderSpec]; //将订单信息签名
//
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",  orderSpec, signedString, @"RSA"];
//    }
//
//    //支付订单，如果安装有支付宝钱包客户端则直接进入客户端，否则进入网页支付
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//
//        NSLog(@"callback reslut = %@",resultDic);
//
//    }];
//
//}
//
//#pragma mark   ============== 产生随机订单号 ==============
//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((unsigned)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}

 
 */