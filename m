Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EE9783569
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Aug 2023 00:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjHUWHJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Aug 2023 18:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjHUWHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2023 18:07:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B329126
        for <linux-xfs@vger.kernel.org>; Mon, 21 Aug 2023 15:07:03 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxUX0003611;
        Mon, 21 Aug 2023 22:06:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=I1bK03icBT93wwLIekEEgGDpPJQrAr6lKMXEc8N7PTA=;
 b=KBpCQ3JxBAi+KDuJQb26k+gzPqfDBmzowtR2CHS8GPHVwOee9OtOSCZQTPUTcM10bAM0
 nB0/01Y+TXHSrgIxL97YHj/s5W894bNr8u1PbiwQ/cBHc3SlDi8B/3z7OkQDgZd89i6h
 PgxykYCL8UfunrOxunfqC5lbPpahrKI1K6Ji5htQdIcsKRr4a8wmrBtjYWK/FMgZBjIH
 WTmPisZO8/wow7BbID3xoebFuMGlpM5l/XxS8Ym0I3pPR7Wt6bGj+SxdpR0tQgpG6V+x
 oVWiiI/VwyMoUV1OLVn6ebR96T7T/nzGt8mq4E+BDZtiXxpUO4vxJS74n5Z4+LjPnsXI 4g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmnc40av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:06:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LKrcxW030373;
        Mon, 21 Aug 2023 22:06:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6422r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:06:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn6yjFuHM85MSsnxu1OjPaEnoQhW/BQfvz7wO3ewb4WO7UlFak3MTrTdX5FcUVTbij3Fwc6S4VDrJ0Df1pbIfbw1A2t1vms0/JGQYUT7QN0TEC+fknIy90fCsV3reybYXpmx0VPWih1gzRL/tw8KNenY+Qo4IudBNpQZTmbYQfJODT6ol5i1Wz5NjvkIsfJfX+oyn/R4mcEpHf0kq7eC/RORSSraMeIIseTpnUyx20IEiEylD7tNaBVpWA68FvgCTwm4QK99dqk7oGBzPRgD3jytMEkYnaJGBKLlphTIfy2AcSxZvdsMNY8ia9xfrtujUpPNYkPHTCiXhbU0ehSIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1bK03icBT93wwLIekEEgGDpPJQrAr6lKMXEc8N7PTA=;
 b=T8lrvffGYm+y+riCexxElZRYKAWuIYKuv/6aUrHrYhW7UlkGp7MrhGjxTmYibg1NrxD5l31ULKv8KUyfQR7G2G3NOKeip+PTrFP9fpHKC0wtzzKEU+NMbaXYg4QjLJiUb75M/Yonc3gS8lmpvhkplBpy8KbpR4R+l+lfk+YcgpME4VCOBwSMZOeunxXRMl18HST9oiQDja2BEqVwsSu+6Gh1HWKyT/nh1hrCFsczuqqgUak82Vu4SSyTZ7Vooun+Ip4DHM/MFHV1+LIxwYP79/fw0LDU1KY2BvbATIU7WvkgHHthu+edj2xrgl1EFP0YYuizgNO400Dm+1DRVJul0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1bK03icBT93wwLIekEEgGDpPJQrAr6lKMXEc8N7PTA=;
 b=z8gAu2qSf7NrVuef9uifFvD952h3qeKYlvG2MfPjN8OTXgjdKx8VGPBmBcRxaqd6VrKqb29W6tpElgdTO8cFKajMWwQ/sQoGhWqMMGJST/PmQ4JI2MTfMjcsr5GoXJwb234tq86vI0DimMo/TwEGgPhsv/6gvE4joHgHa7BYzoI=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by MW4PR10MB6322.namprd10.prod.outlook.com (2603:10b6:303:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 22:06:46 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::3730:5db3:bd47:8392]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::3730:5db3:bd47:8392%4]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 22:06:45 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Thread-Topic: Question: reserve log space at IO time for recover
Thread-Index: AQHZuctArDqu+2gh/UuDZaYn7kAqiq/AN2uAgAAaCICAAE50gIAEAZ+AgAN+qQCAAR5UAIACO3SAgAQL+wCAIA3CgIAF8DKA
Date:   Mon, 21 Aug 2023 22:06:45 +0000
Message-ID: <27B173AA-8203-42E5-85CC-FB5F380521FB@oracle.com>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
In-Reply-To: <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|MW4PR10MB6322:EE_
x-ms-office365-filtering-correlation-id: 5acf87db-65b6-4d6e-de32-08dba292e8db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cAf6NrhkRrH+EcXWLwau3KKzMQ2oGmSXp/ZiUz+WfS2wMzq8el93wByozsm8Qa/A8NWWrT+9WA2g2/+EQlBHnqTt7a0qjGI4nxGsX0fX6ef5+dJL1l9BHdG1+z4gHGLOoMi9CnPDieozxPxTAvnJpq0DygthO/AtD8MloeZU7LHHTeR0Ac6S5iuRGdTSR3op2OwnUhOWYOwVpAhxkw2dLG9DyhVMH0Pv0OEZiP10i/rdpbKE67kIF8N/dkN4xnOURK51tu2J5lNE3DP23OC/toHBaJfSTCSgJTbTkihhpCl878GfWNwQ3yn9yYbQdHtMjHTSPYGzeXATp9OIkRU6gt5fTOdlHoWl10p26OvZ9fN1y50LKQbySLrWHXi1TtU5P+Dbu0N/vBoZIvEqTLWnKiiq+GDDFbWXVyInYSonfibr5pyebpDNq6blIXJ2OOcR04jYdDECBUICYLiNXS7B5K+X2hd33/4oU2ppwX3/RxTs0tHPpzpjnpDP3lCV8/mCRHaFNuG0G3yu/FlttfZIzsitF2feH077tWmw/uJNnDMwHcmni7nKC0VsAVoyBKoSdqOri3OL60Is7diAl0vE5m5igrNkrX0PJ8KbTEsNkRWMrm74dt0bgzLVH1PVROBXu6EAWTbFr+Oa1+koqPO+kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66446008)(76116006)(66476007)(66556008)(64756008)(316002)(6512007)(66946007)(8676002)(8936002)(2616005)(107886003)(4326008)(36756003)(41300700001)(122000001)(478600001)(71200400001)(38100700002)(38070700005)(53546011)(6506007)(6486002)(83380400001)(2906002)(86362001)(5660300002)(33656002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnBUOHluaXRtcGRteTlZc2NXeFg5WlRBWEF6VFB1c2hMMFZ5M3lxTlp0L3Q4?=
 =?utf-8?B?R3JkZmMyd2R3U3JZblluZGtOS04xZ1drUzdjSlE1VkFzMnhkdlR5ZU1lYngx?=
 =?utf-8?B?V2xYVzcwNktBWTBmc29TcklHNmlLL2pOc0VGcVZSVDcrRkU4dUdsbEJGWnBv?=
 =?utf-8?B?S3JJVSt2OHVLZnUyYllUSzh0ejZJMi93bmZlTnNVM2JSYU1KTitFbEhrTkcy?=
 =?utf-8?B?VTVQWXgvV0hoWVdOOXl0bWxrcnpvU25Zck55WDRhMEtRRGhIcHR2VGJoWG1J?=
 =?utf-8?B?a1EvOGtrZmZwZ3ZRY2dNUWZPTW13VDFZdWFGb3g1SmRWazdqK0xvRGZZSzhG?=
 =?utf-8?B?a0s1S1VJd2JEM3BrSHA0RGczWXd0VXFya2lMVHV1RjN0cit2NjY2TExaQk1J?=
 =?utf-8?B?cnQxMmsrUDV0NEt1TFZXZytoNmZvNTdzQnduKy9ZUmM0Q1RDaXpEa3NQdXNR?=
 =?utf-8?B?Zk4wVHFxeTBPL0RmYm1hRFUxUnVObyttZVhCcjhxSVQwc1EwSjZSUG13SCtH?=
 =?utf-8?B?WU5MYUh1RGpVeG9tVEtjL3ZmZ1N1SERIQk1KcFhVRjFYYjYwVGpjQzE5RTRw?=
 =?utf-8?B?aFBlSTBNU0c0STJNcGFhMkRSQncrRmMvelVBUWcxb3M4dTlkaDlwVVFWQXF5?=
 =?utf-8?B?ZFJZSllUQVJLTTFwQ1BWT3pIaUp1WnlHd2piRDVBa0F5dzJaZGd0T213VkhH?=
 =?utf-8?B?clFLMk9YZGN1azRqOGZLdVJYcUFoRVBZU3BzSnNSVWtXS3BPV1JMR0haWWxV?=
 =?utf-8?B?Z0Y0d1g2Q0Y0bVR2WUZhcDlYdXRRemlCc2pXRktVdzA1d1IyczIrbjNOQW1z?=
 =?utf-8?B?U2Q4NTg3NC95VXhHT2tXK2twY2lBTDQ3VzFsQzcySE0zUWRSckZZZFE5aWxs?=
 =?utf-8?B?LzNTVlcxeWhLVkcwY3RhN2pwVXlTcGdtYTBpMnFrNER2bTA2dFBBWWRXYk1J?=
 =?utf-8?B?WWUrNTBPdFlCeWhZR1p1dGxMTm5UZnZTd1JqaEV0QkVjZ1ovb083U2lSL1cr?=
 =?utf-8?B?NEpEai85RmlxNHJjNzRicXBqZUdMWTg2UWdLbnpLLzI1WDU4UnhQR2hkRTg1?=
 =?utf-8?B?b3Urc2x0Unp1VzhZdmxHcUc1bTZCTm42VXVTSXFxWklab0EzR2FXK2NJRlg1?=
 =?utf-8?B?dE02bjZSOXdWc3JPU0FSVlMzMXAyblFQbmJnWjl6RTRvZGdFU0I5Z3NXWkZF?=
 =?utf-8?B?eTlWa0VTQjVhSkJ5M3d0VENLSDBKV3NTNkxnZGlWdWtCN0p1RmlrWUZKTjN6?=
 =?utf-8?B?Sk0ySktkN2NzeHY2dVdvbUNrOGgxTlJ4U0J3MnZnUGxaZEUweUx4dzFtdUVq?=
 =?utf-8?B?L1dxME9Hc2xUYmk5aFFJZklBM3dhbVh1YWgwV2o3QTUwRUU2dkUrUS9BZUUz?=
 =?utf-8?B?aVdHMDROUG1VbWtLcWt3clFYbEE5WEptVmdmK3FiTmhsN1dGTitSYlpLUkg3?=
 =?utf-8?B?U1VUYnBndEFISTZ4aG1kRzZFL3pCY1RiM0JPRUI5TjJNUy9zdkh1dldoM0xx?=
 =?utf-8?B?ZFV2dkpkeWZWUUo2NFhqcmFQQWpDempySUNkL2U2RDBCa3N0Y2tSNGlQU0Qr?=
 =?utf-8?B?emV4ODFiWnJMcW9NcDBpUVVqcmpWWUgxR1RrekF4enNNL2pjTXEreTN4MUFU?=
 =?utf-8?B?RUdVMW5Qd0tFN2xKUUZ1K2ZteE1tc0NqTm8zWG41TUYxVXdaci9GSGF3d2Vh?=
 =?utf-8?B?WWtSdUhrNXh6ajg0bUZoMXo1elhkRTZZazljR1IzM0JCVEQyVkJTOW1sY3RK?=
 =?utf-8?B?L2QvNTJqbG1XR09sM2Q4bit2elNMRkYxY2hER0U2YWlhZjZCaXBxUW42QlNW?=
 =?utf-8?B?c1ZEM0VFRnBHWVZ2REZObmkzaEpCazhqS2tOZnhrZUlQRDB0RzJNN0F0YWFP?=
 =?utf-8?B?emFLeFhIQVY2bE52U2dHRXVjelo0YVp1ZFRjVWVYcDN2Z1Y5MWRCS1RMWjBN?=
 =?utf-8?B?ckVxMU5PcEJoVWpEcTF6OWFIcitudTF4K0ZVRmRzYzArN25IZ2VrejBxZjNM?=
 =?utf-8?B?QWRnaitlcE5ZU3NOckVWTEl2SmIweDVqajd3Q0hlQ09UdmRnUDYvdmFRNDcv?=
 =?utf-8?B?Y3BzaFExQ2xreWx6NjFRWGV5aGxHV0E4UWRRdU1LbU0rcm4xb1V0RkVzV3hx?=
 =?utf-8?B?ZlVIOUZiL0luRjRqYVEyb0pxRlpTNWwybFg5ODlXK1VkRVVseUtleUl4K0l6?=
 =?utf-8?B?ekE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7A3633CB13AF7408C8A430620EA7591@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: g1HfGXR4iGFDGdWlcBocOnqDACyJy/75t/8zYSJBUHbs00zRw1aU6SMZO6zlwlYok/Ak1GT7lDxqPYsHQmNbSlnt7W6+1YjVgMtBEonNIbjG1heNO0SW8Dx0OrUfm+kYxN74LfZJfbIIxNHE6YqwjxDNJV4IxHoun1xbzd2euvcXd2zWGxsq4+osTbBg5n93ELKeuNse9aViSMLEWAfCwuXQ+Twc2WQpno+zhKeT1NMt52oE14/JVSd1JZvKZ3H6l/YGbbgtF+mKDjhr6t2fOoSXHcOcKqxhFs1dVTgJ/1RYV3IXhPVq9IB7Y/SRF9Yj5vay+x/mfildii0rqKpaauXXOX7bE0iy2AzRgbV8tNZxWCrB7lJJIeejgPmHRZKBLyPirLHa+Qfx2mvC9f3JCcrkZvHZOphFXtHARFA1ReIqpw38oYi+tn86zZYu8ooJBtdLoMgBCbgm4bYJic8eWbB0nLChdLmmkZY0jtIUGqqICCrim3NMBwDX3ykLOcE+/jn59WRmRCDvLtikU+gT6Q0XWiUqZtIlQO+dfx4T/3lHfT3ZrC03AYWICPQmpQth766JLVOwBjZveRc77qANS0CbgVgZLNFLHoBmdAX7SWu5EhaxL87+BStfY/at4yJe9W8NqZ1EusTyfg91HhOGTB1jZ6zPD7HPWkq9lH8SHTyRTchlxGLwRuhzgVUaCw6RVM0qWq20Seqhp4l74pWvAWvYJlbcmxhy1OLVp92vE2E9cDNAaBZPlvYsmtF9tt0/j+XDsfzj2Oxn7AvI6WFw6+c8g+bjCqaKyaddY/RQD8Zl8cdHy6n374zMXohlPvYhbibhnT3yzyqjPqog9iweQg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5acf87db-65b6-4d6e-de32-08dba292e8db
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2023 22:06:45.8664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yt4qRP5boVAQMgguDiNtcdQJiWIWLRWiOe/XniF8PWNU71EamkwrU8PbKm97Jq7qyTg8IxOG55koFXAWfAwPqSzabltcm5bfw5LX3ztEShA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210203
X-Proofpoint-GUID: 71fjzaSqdQHCP0Fl02Fa7Y7BVGs8AGpp
X-Proofpoint-ORIG-GUID: 71fjzaSqdQHCP0Fl02Fa7Y7BVGs8AGpp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gQXVnIDE3LCAyMDIzLCBhdCA4OjI1IFBNLCBXZW5nYW5nIFdhbmcgPHdlbi5nYW5n
LndhbmdAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBXaGF0IHRoaW5ncyBsb29rcyB0byBiZToN
Cj4gDQo+IEZvciB0aGUgZmlsZSBkZWxldGlvbi4gIGxvZyBieXRlcyBhcmUgcmVzZXJ2ZWQgYmFz
aW5nIG9uIHhmc19tb3VudC0+dHJfaXRydW5jYXRlIHdoaWNoIGlzOg0KPiB7DQo+ICAgIHRyX2xv
Z3JlcyA9IDE3NTQ4OCwNCj4gICAgdHJfbG9nY291bnQgPSAyLA0KPiAgICB0cl9sb2dmbGFncyA9
IFhGU19UUkFOU19QRVJNX0xPR19SRVMsDQo+IH0gIA0KPiBZb3Ugc2VlIGl04oCZcyBwZXJtYW5l
bnQgbG9nIHJlc2VydmF0aW9uIHdpdGggdHdvIGxvZyBvcGVyYXRpb25zICh0d28gdHJhbnNhY3Rp
b25zIGluIHJvbGxpbmcgbW9kZSkuDQo+IEFmdGVyIGNhbGN1bGF0aW9uICh4bG9nX2NhbGNfdW5p
dF9yZXMoKSwgYWRkaW5nIHNwYWNlIGZvciB2YXJpb3VzIGxvZyBoZWFkZXJzKSwgdGhlIGZpbmFs
DQo+IGxvZyBzcGFjZSBuZWVkZWQgcGVyIHRyYW5zYWN0aW9uIGNoYW5nZXMgZnJvbSAgMTc1NDg4
IHRvIDE4MDIwOCBieXRlcy4gU28gdGhlIHRvdGFsDQo+IGxvZyBzcGFjZSBuZWVkZWQgaXMgMzYw
NDE2ICgxODAyMDggKiAyKS4gICANCj4gQWJvdmUgbG9nIHNwYWNlICgzNjA0MTYgYnl0ZXMpIG5l
ZWRzIHRvIGJlIHJlc2VydmVkIGZvciBib3RoIHJ1biB0aW1lIGlub2RlIHJlbW92aW5nDQo+ICh4
ZnNfaW5hY3RpdmVfdHJ1bmNhdGUoKSkgYW5kIEVGSSByZWNvdmVyICh4ZnNfZWZpX2l0ZW1fcmVj
b3ZlcigpKS4NCj4gDQo+IFJVTlRJTUUNCj4gPT09PT09PT0NCj4gDQo+IEZvciBydW4gdGltZSBp
bm9kZSByZW1vdmluZy4gVGhlIGZpcnN0IHRyYW5zYWN0aW9uIGlzIG1haW5seSB1c2VkIGZvciBp
bm9kZSBmaWVsZHMgY2hhbmdlLg0KPiBUaGUgc2Vjb25kIHRyYW5zYWN0aW9uIGlzIHVzZWQgZm9y
IGludGVudHMgaW5jbHVkaW5nIGV4dGVudCBmcmVlaW5nLg0KPiANCj4gRm9yIHRoZSBmaXJzdCB0
cmFuc2FjdGlvbiwgaXQgaGFzIDE4MDIwOCByZXNlcnZlZCBsb2cgYnl0ZXMgKGFub3RoZXIgMTgw
MjA4IGJ5dGVzIHJlc2VydmVkDQo+IGZvciB0aGUgY29taW5nIHRyYW5zYWN0aW9uKS4gIA0KPiBU
aGUgZmlyc3QgdHJhbnNhY3Rpb24gaXMgY29tbWl0dGVkLCB3cml0aW5nIHNvbWUgYnl0ZXMgdG8g
bG9nIGFuZCByZWxlYXNpbmcgdGhlIGxlZnQgcmVzZXJ2ZWQgYnl0ZXMuDQo+IA0KPiBOb3cgd2Ug
aGF2ZSB0aGUgc2Vjb25kIHRyYW5zYWN0aW9uIHdoaWNoIGhhcyAxODAyMDggbG9nIGJ5dGVzIHJl
c2VydmVkIHRvby4gVGhlIHNlY29uZA0KPiB0cmFuc2FjdGlvbiBpcyBzdXBwb3NlZCB0byBwcm9j
ZXNzIGludGVudHMgaW5jbHVkaW5nIGV4dGVudCBmcmVlaW5nLiBXaXRoIG15IGhhY2tpbmcgcGF0
Y2gsDQo+IEkgYmxvY2tlZCB0aGUgZXh0ZW50IGZyZWVpbmcgNSBob3Vycy4gU28gaW4gdGhhdCA1
IGhvdXJzLCAgMTgwMjA4IChOT1QgMzYwNDE2KSBsb2cgYnl0ZXMgYXJlIHJlc2VydmVkLg0KPiAN
Cj4gV2l0aCBteSB0ZXN0IGNhc2UsIG90aGVyIHRyYW5zYWN0aW9ucyAodXBkYXRlIHRpbWVzdGFt
cHMpIHRoZW4gaGFwcGVuLiBBcyBteSBoYWNraW5nIHBhdGNoDQo+IHBpbnMgdGhlIGpvdXJuYWwg
dGFpbCwgdGhvc2UgdGltZXN0YW1wLXVwZGF0aW5nIHRyYW5zYWN0aW9ucyBmaW5hbGx5IHVzZSB1
cCAoYWxtb3N0KSBhbGwgdGhlIGxlZnQgYXZhaWxhYmxlDQo+IGxvZyBzcGFjZSAoaW4gbWVtb3J5
IGluIG9uIGRpc2spLiAgQW5kIGZpbmFsbHkgdGhlIG9uIGRpc2sgKGFuZCBpbiBtZW1vcnkpIGF2
YWlsYWJsZSBsb2cgc3BhY2UNCj4gZ29lcyBkb3duIG5lYXIgdG8gMTgwMjA4IGJ5dGVzLiBUaG9z
ZSAxODAyMDggYnl0ZXMgYXJlIHJlc2VydmVkIGJ5IGFib3ZlIHNlY29uZCAoZXh0ZW50LWZyZWUp
DQo+IHRyYW5zYWN0aW9uLg0KPiANCj4gUGFuaWMgdGhlIGtlcm5lbCBhbmQgcmVtb3VudCB0aGUg
eGZzIHZvbHVtZQ0KPiANCj4gTE9HIFJFQ09WRVINCj4gPT09PT09PT09PT09PQ0KPiANCj4gV2l0
aCBsb2cgcmVjb3ZlciwgZHVyaW5nIEVGSSByZWNvdmVyLCB3ZSB1c2UgdHJfaXRydW5jYXRlIGFn
YWluIHRvIHJlc2VydmUgdHdvIHRyYW5zYWN0aW9ucyB0aGF0IG5lZWRzDQo+IDM2MDQxNiBsb2cg
Ynl0ZXMuIFJlc2VydmluZyAzNjA0MTYgYnl0ZXMgZmFpbHMgKGJsb2NrcykgYmVjYXVzZSB3ZSBu
b3cgb25seSBoYXZlIGFib3V0IDE4MDIwOCBhdmFpbGFibGUuDQo+IA0KPiBUSElOS0lORw0KPiA9
PT09PT09PQ0KPiBBY3R1YWxseSBkdXJpbmcgdGhlIEVGSSByZWNvdmVyLCB3ZSBvbmx5IG5lZWQg
b25lIHRyYW5zYWN0aW9uIHRvIGZyZWUgdGhlIGV4dGVudHMganVzdCBsaWtlIHRoZSAybmQNCj4g
dHJhbnNhY3Rpb24gYXQgUlVOVElNRS4gU28gaXQgb25seSBuZWVkcyB0byByZXNlcnZlIDE4MDIw
OCByYXRoZXIgdGhhbiAzNjA0MTYgYnl0ZXMuICBXZSBoYXZlDQo+IChhIGJpdCkgbW9yZSB0aGFu
IDE4MDIwOCBhdmFpbGFibGUgbG9nIGJ5dGVzICBvbiBkaXNrLCBzbyB0aGUgcmVzZXJ2YXRpb24g
Z29lcyBhbmQgdGhlIHJlY292ZXJ5IGdvZXMuDQo+IFRoYXQgaXMgdG8gc2F5OiB3ZSBjYW4gZml4
IHRoZSBsb2cgcmVjb3ZlciBwYXJ0IHRvIGZpeCB0aGUgaXNzdWUuIFdlIGNhbiBpbnRyb2R1Y2Ug
YSBuZXcgeGZzX3RyYW5zX3Jlcw0KPiB4ZnNfbW91bnQtPnRyX2V4dF9mcmVlDQo+IHsNCj4gICAg
dHJfbG9ncmVzID0gMTc1NDg4LA0KPiAgICB0cl9sb2djb3VudCA9IDAsDQo+ICAgIHRyX2xvZ2Zs
YWdzID0gMCwNCj4gfQ0KPiBhbmQgdXNlIHRyX2V4dF9mcmVlIGluc3RlYWQgb2YgdHJfaXRydW5j
YXRlIGluIEVGSSByZWNvdmVyLiAoZGlkbuKAmXQgdHJ5IGl0KS4NCj4gDQoNClRoZSBmb2xsb3dp
bmcgcGF0Y2ggcmVjb3ZlcnMgdGhlIHByb2JsZW1hdGljIFhGUyB2b2x1bWUgYnkgbXkgaGFja2Vk
IGtlcm5lbCBhbmQgdGhlIGFsc28NCnRoZSBvbmUgZnJvbSBjdXN0b21lci4NCg0KY29tbWl0IDE5
ZmFkOTAzZTIxMzcxN2E5MmY4Yjk0ZmUyYzBjNjhiNmE2ZWU3ZjcgKEhFQUQgLT4gMzU1ODcxNjNf
Zml4KQ0KQXV0aG9yOiBXZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4NCkRh
dGU6ICAgTW9uIEF1ZyAyMSAxNTowMzo1OCAyMDIzIC0wNzAwDQoNCiAgICB4ZnM6IHJlc2VydmUg
bGVzcyBsb2cgc3BhY2Ugd2hlbiByZWNvdmVyaW5nIEVGSXMNCg0KICAgIEN1cnJlbnRseSB0cl9p
dHJ1bmNhdGUgaXMgdXNlZCBmb3IgYm90aCBydW4gdGltZSB0cnVuY2F0aW5nIGFuZA0KICAgIGJv
b3QgdGltZSBFRkkgcmVjb3ZlcnkuIHRyX2l0cnVuY2F0ZQ0KICAgIHsNCiAgICAgICB0cl9sb2dy
ZXMgPSAxNzU0ODgsDQogICAgICAgdHJfbG9nY291bnQgPSAyLA0KICAgICAgIHRyX2xvZ2ZsYWdz
ID0gWEZTX1RSQU5TX1BFUk1fTE9HX1JFUywNCiAgICB9DQoNCiAgICBJcyBhIHBlcm1hbmVudCB0
d28tdHJhbnNhY3Rpb24gc2VyaWVzLiBBY3R1YWxseSBvbmx5IHRoZSBzZWNvbmQgdHJhbnNhY3Rp
b24NCiAgICBpcyByZWFsbHkgdXNlZCB0byBmcmVlIGV4dGVudHMgYW5kIHRoYXQgbmVlZHMgaGFs
ZiBvZiB0aGUgbG9nIHNwYWNlIHJlc2VydmF0aW9uDQogICAgZnJvbSB0cl9pdHJ1bmNhdGUuDQoN
CiAgICBGb3IgRUZJIHJlY292ZXJ5LCB0aGUgdGhpbmdzIHRvIGRvIGlzIGp1c3QgdG8gZnJlZSBl
eHRlbnRzLCBzbyBpdCBkb2Vzbid0DQogICAgbmVlZHMgZnVsbCBsb2cgc3BhY2UgcmVzZXJ2YXRp
b24gYnkgdHJfaXRydW5jYXRlLiBJdCBuZWVkcyBoYWxmIG9mIGl0IGFuZA0KICAgIHNob3VsZG4n
dCBuZWVkIG1vcmUgdGhhbiB0aGF0Lg0KDQogICAgU2lnbmVkLW9mZi1ieTogV2VuZ2FuZyBXYW5n
IDx3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+DQoNCmRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2V4
dGZyZWVfaXRlbS5jIGIvZnMveGZzL3hmc19leHRmcmVlX2l0ZW0uYw0KaW5kZXggZjFhNWVjZjA5
OWFhLi40Mjg5ODRlNDhkMjMgMTAwNjQ0DQotLS0gYS9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5j
DQorKysgYi9mcy94ZnMveGZzX2V4dGZyZWVfaXRlbS5jDQpAQCAtNjY3LDYgKzY2Nyw3IEBAIHhm
c19lZmlfaXRlbV9yZWNvdmVyKA0KICAgICAgICBpbnQgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGk7DQogICAgICAgIGludCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXJyb3IgPSAw
Ow0KICAgICAgICBib29sICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJlcXVldWVfb25seSA9
IGZhbHNlOw0KKyAgICAgICBzdHJ1Y3QgeGZzX3RyYW5zX3JlcyAgICAgICAgICAgIHRyZXM7DQoN
CiAgICAgICAgLyoNCiAgICAgICAgICogRmlyc3QgY2hlY2sgdGhlIHZhbGlkaXR5IG9mIHRoZSBl
eHRlbnRzIGRlc2NyaWJlZCBieSB0aGUNCkBAIC02ODMsNyArNjg0LDEwIEBAIHhmc19lZmlfaXRl
bV9yZWNvdmVyKA0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KDQotICAgICAgIGVycm9y
ID0geGZzX3RyYW5zX2FsbG9jKG1wLCAmTV9SRVMobXApLT50cl9pdHJ1bmNhdGUsIDAsIDAsIDAs
ICZ0cCk7DQorICAgICAgIHRyZXMudHJfbG9ncmVzID0gTV9SRVMobXApLT50cl9pdHJ1bmNhdGUu
dHJfbG9ncmVzOw0KKyAgICAgICB0cmVzLnRyX2xvZ2NvdW50ID0gMDsNCisgICAgICAgdHJlcy50
cl9sb2dmbGFncyA9IDA7DQorICAgICAgIGVycm9yID0geGZzX3RyYW5zX2FsbG9jKG1wLCAmdHJl
cywgMCwgMCwgMCwgJnRwKTsNCiAgICAgICAgaWYgKGVycm9yKQ0KICAgICAgICAgICAgICAgIHJl
dHVybiBlcnJvcjsNCiAgICAgICAgZWZkcCA9IHhmc190cmFuc19nZXRfZWZkKHRwLCBlZmlwLCBl
ZmlwLT5lZmlfZm9ybWF0LmVmaV9uZXh0ZW50cyk7DQoNCnRoYW5rcywNCndlbmdhbmcNCg0KPiB0
aGFua3MsDQo+IHdlbmdhbmcNCj4gDQo+PiBPbiBKdWwgMjgsIDIwMjMsIGF0IDEwOjU2IEFNLCBX
ZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4gd3JvdGU6DQo+PiANCj4+IA0K
Pj4gDQo+Pj4gT24gSnVsIDI1LCAyMDIzLCBhdCA5OjA4IFBNLCBEYXZlIENoaW5uZXIgPGRhdmlk
QGZyb21vcmJpdC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIE1vbiwgSnVsIDI0LCAyMDIzIGF0
IDA2OjAzOjAyUE0gKzAwMDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+Pj4+IE9uIEp1bCAyMywg
MjAyMywgYXQgNTo1NyBQTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90
ZToNCj4+Pj4+IE9uIEZyaSwgSnVsIDIxLCAyMDIzIGF0IDA3OjM2OjAzUE0gKzAwMDAsIFdlbmdh
bmcgV2FuZyB3cm90ZToNCj4+Pj4+PiBGWUk6DQo+Pj4+Pj4gDQo+Pj4+Pj4gSSBhbSBhYmxlIHJl
cHJvZHVjZSB0aGUgWEZTIG1vdW50IGhhbmcgaXNzdWUgd2l0aCBoYWNrZWQga2VybmVscyBiYXNl
ZCBvbg0KPj4+Pj4+IGJvdGggNC4xNC4zNSBrZXJuZWwgb3IgNi40LjAga2VybmVsLg0KPj4+Pj4+
IFJlcHJvZHVjZSBzdGVwczoNCj4+Pj4+PiANCj4+Pj4+PiAxLiBjcmVhdGUgYSBYRlMgd2l0aCAx
ME1pQiBsb2cgc2l6ZSAoc21hbGwgc28gZWFzaWVyIHRvIHJlcHJvZHVjZSkuIFRoZSBmb2xsb3dp
bmcNCj4+Pj4+PiBzdGVwcyBhbGwgYWltIGF0IHRoaXMgWEZTIHZvbHVtZS4NCj4+Pj4+IA0KPj4+
Pj4gQWN0dWFsbHksIG1ha2UgdGhhdCBhIGZldyBtaWxsaXNlY29uZHMuLi4uIDopDQo+Pj4+IA0K
Pj4+PiA6KQ0KPj4+PiANCj4+Pj4+IG1rZnMveGZzX2luZm8gb3V0cHV0IHdvdWxkIGJlIGFwcHJl
Y2lhdGVkLg0KPj4+PiANCj4+Pj4gc3VyZSwNCj4+Pj4gIyB4ZnNfaW5mbyAyMEdCLmJrMg0KPj4+
PiBtZXRhLWRhdGE9MjBHQi5iazIgICAgICAgICAgICAgICBpc2l6ZT0yNTYgICAgYWdjb3VudD00
LCBhZ3NpemU9MTMxMDcyMCBibGtzDQo+Pj4+ICAgICAgID0gICAgICAgICAgICAgICAgICAgICAg
IHNlY3Rzej01MTIgICBhdHRyPTIsIHByb2ppZDMyYml0PTENCj4+Pj4gICAgICAgPSAgICAgICAg
ICAgICAgICAgICAgICAgY3JjPTAgICAgICAgIGZpbm9idD0wLCBzcGFyc2U9MCwgcm1hcGJ0PTAN
Cj4+Pj4gICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgcmVmbGluaz0wDQo+Pj4gDQo+Pj4g
SG1tbW0uIFdoeSBhcmUgeW91IG9ubHkgdGVzdGluZyB2NCBmaWxlc3lzdGVtcz8gVGhleSBhcmUg
ZGVwcmVjYXRlZA0KPj4+IGFuZCBzdXBwb3J0IGlzIGxhcmdlbHkgZHVlIHRvIGJlIGRyb3BwZWQg
ZnJvbSB1cHN0cmVhbSBpbiAyMDI1Li4uDQo+Pj4gDQo+PiANCj4+IEhhLCBpdCBqdXN0IGhhcHBl
bmVkIHRvIGJlIHNvLg0KPj4gSSB3YXMgdHJ5aW5nIHRvIHJlcHJvZHVjZSBpdCBpbiB0aGUgc2Ft
ZSBlbnZpcm9ubWVudCBhcyBjdXN0b21lciBoYXMg4oCUDQo+PiB0aGF04oCZcyBPcmFjbGVMaW51
eDcuIFRoZSBkZWZhdWx0IGJlaGF2aW9yIG9mIG1rZnMueGZzIGluIE9MNyBpcyB0byBmb3JtYXQN
Cj4+IHY0IGZpbGVzeXN0ZW1zLiAgSSBjcmVhdGVkIHRoZSB4ZnMgaW1hZ2UgaW4gYSBmaWxlIG9u
IE9MNyBhbmQgY29waWVkIHRoZSBpbWFnZQ0KPj4gZmlsZSB0byBhIDYuNC4wIGtlcm5lbCBtYWNo
aW5lLiBUaGF04oCZcyB3aHkgeW91IHNlZSB2NCBmaWxlc3lzdGVtIGhlcmUuDQo+PiANCj4+PiBE
b2VzIHRoZSBzYW1lIHByb2JsZW0gb2NjdXIgd2l0aCBhIHY1IGZpbGVzeXN0ZW1zPw0KPj4gDQo+
PiBXaWxsIHRlc3QgYW5kIHJlcG9ydCBiYWNrLg0KPj4gDQo+Pj4gDQo+Pj4+Pj4gNS4gQ2hlY2tp
bmcgdGhlIG9uIGRpc2sgbGVmdCBmcmVlIGxvZyBzcGFjZSwgaXTigJlzIDE4MTc2MCBieXRlcyBm
b3IgYm90aCA0LjE0LjM1DQo+Pj4+Pj4ga2VybmVsIGFuZCA2LjQuMCBrZXJuZWwuDQo+Pj4+PiAN
Cj4+Pj4+IFdoaWNoIGlzIGlzIGNsZWFybHkgd3JvbmcuIEl0IHNob3VsZCBiZSBhdCBsZWFzdCAz
NjA0MTYgYnl0ZXMgKGkuZQ0KPj4+Pj4gdHJfaXRydW5jKSwgYmVjYXVzZSB0aGF0J3Mgd2hhdCB0
aGUgRUZJIGJlaW5nIHByb2Nlc3NlZCB0aGF0IHBpbnMNCj4+Pj4+IHRoZSB0YWlsIG9mIHRoZSBs
b2cgaXMgc3VwcG9zZWQgdG8gaGF2ZSByZXNlcnZlZCB3aGVuIGl0IHdhcw0KPj4+Pj4gc3RhbGxl
ZC4NCj4+Pj4gDQo+Pj4+IFllcCwgZXhhY3RseS4NCj4+Pj4gDQo+Pj4+PiBTbyB3aGVyZSBoYXMg
dGhlIH4xODBrQiBvZiBsZWFrZWQgc3BhY2UgY29tZSBmcm9tPw0KPj4+Pj4gDQo+Pj4+PiBIYXZl
IHlvdSB0cmFjZWQgdGhlIGdyYW50IGhlYWQgcmVzZXJ2YXRpb25zIHRvIGZpbmQgb3V0DQo+Pj4+
PiB3aGF0IHRoZSBydW50aW1lIGxvZyBzcGFjZSBhbmQgZ3JhbnQgaGVhZCByZXNlcnZhdGlvbnMg
YWN0dWFsbHkgYXJlPw0KPj4+PiBJIGhhdmUgdGhlIG51bWJlcnMgaW4gdm1jb3JlIChpZ25vcmUg
dGhlIFdBUk5zKSwNCj4+PiANCj4+PiBUaGF0J3Mgbm90IHdoYXQgSSdtIGFza2luZy4gWW91J3Zl
IGR1bXBlZCB0aGUgdmFsdWVzIGF0IHRoZSB0aW1lIG9mDQo+Pj4gdGhlIGhhbmcsIG5vdCB0cmFj
ZWQgdGhlIHJ1bnRpbWUgcmVzZXJ2YXRpb25zIHRoYXQgaGF2ZSBiZWVuIG1hZGUuDQo+Pj4gDQo+
Pj4+PiBpLmUuIHdlIGhhdmUgZnVsbCB0cmFjaW5nIG9mIHRoZSBsb2cgcmVzZXJ2YXRpb24gYWNj
b3VudGluZyB2aWENCj4+Pj4+IHRyYWNlcG9pbnRzIGluIHRoZSBrZXJuZWwuIElmIHRoZXJlIGlz
IGEgbGVhayBvY2N1cnJpbmcsIHlvdSBuZWVkIHRvDQo+Pj4+PiBjYXB0dXJlIGEgdHJhY2Ugb2Yg
YWxsIHRoZSByZXNlcnZhdGlvbiBhY2NvdW50aW5nIG9wZXJhdGlvbnMgYW5kDQo+Pj4+PiBwb3N0
IHByb2Nlc3MgdGhlIG91dHB1dCB0byBmaW5kIG91dCB3aGF0IG9wZXJhdGlvbiBpcyBsZWFraW5n
DQo+Pj4+PiByZXNlcnZlZCBzcGFjZS4gZS5nLg0KPj4+Pj4gDQo+Pj4+PiAjIHRyYWNlLWNtZCBy
ZWNvcmQgLWUgeGZzX2xvZ1wqIC1lIHhsb2dcKiAtZSBwcmludGsgdG91Y2ggL21udC9zY3JhdGNo
L2Zvbw0KPj4+Pj4gLi4uLg0KPj4+Pj4gIyB0cmFjZS1jbWQgcmVwb3J0ID4gcy50DQo+Pj4+PiAj
IGhlYWQgLTMgcy50DQo+Pj4+PiBjcHVzPTE2DQo+Pj4+PiAgICAgICB0b3VjaC0yODkwMDAgWzAw
OF0gNDMwOTA3LjYzMzgyMDogeGZzX2xvZ19yZXNlcnZlOiAgICAgIGRldiAyNTM6MzIgdF9vY250
IDIgdF9jbnQgMiB0X2N1cnJfcmVzIDI0MDg4OCB0X3VuaXRfcmVzIDI0MDg4OCB0X2ZsYWdzIFhM
T0dfVElDX1BFUk1fUkVTRVJWIHJlc2VydmVxIGVtcHR5IHdyaXRlcSBlbXB0eSBncmFudF9yZXNl
cnZlX2N5Y2xlIDEgZ3JhbnRfcmVzZXJ2ZV9ieXRlcyAxMDI0IGdyYW50X3dyaXRlX2N5Y2xlIDEg
Z3JhbnRfd3JpdGVfYnl0ZXMgMTAyNCBjdXJyX2N5Y2xlIDEgY3Vycl9ibG9jayAyIHRhaWxfY3lj
bGUgMSB0YWlsX2Jsb2NrIDINCj4+Pj4+ICAgICAgIHRvdWNoLTI4OTAwMCBbMDA4XSA0MzA5MDcu
NjMzODI5OiB4ZnNfbG9nX3Jlc2VydmVfZXhpdDogZGV2IDI1MzozMiB0X29jbnQgMiB0X2NudCAy
IHRfY3Vycl9yZXMgMjQwODg4IHRfdW5pdF9yZXMgMjQwODg4IHRfZmxhZ3MgWExPR19USUNfUEVS
TV9SRVNFUlYgcmVzZXJ2ZXEgZW1wdHkgd3JpdGVxIGVtcHR5IGdyYW50X3Jlc2VydmVfY3ljbGUg
MSBncmFudF9yZXNlcnZlX2J5dGVzIDQ4MjgwMCBncmFudF93cml0ZV9jeWNsZSAxIGdyYW50X3dy
aXRlX2J5dGVzIDQ4MjgwMCBjdXJyX2N5Y2xlIDEgY3Vycl9ibG9jayAyIHRhaWxfY3ljbGUgMSB0
YWlsX2Jsb2NrIDINCj4+Pj4+IA0KPj4+Pj4gIw0KPj4+Pj4gDQo+Pj4+PiBTbyB0aGlzIHRlbGxz
IHVzIHRoZSB0cmFuc2FjdGlvbiByZXNlcnZhdGlvbiB1bml0IHNpemUsIHRoZSBjb3VudCBvZg0K
Pj4+Pj4gcmVzZXJ2YXRpb25zLCB0aGUgY3VycmVudCByZXNlcnZlIGFuZCBncmFudCBoZWFkIGxv
Y2F0aW9ucywgYW5kIHRoZQ0KPj4+Pj4gY3VycmVudCBoZWFkIGFuZCB0YWlsIG9mIHRoZSBsb2cg
YXQgdGhlIHRpbWUgdGhlIHRyYW5zYWN0aW9uDQo+Pj4+PiByZXNlcnZhdGlvbiBpcyBzdGFydGVk
IGFuZCB0aGVuIGFmdGVyIGl0IGNvbXBsZXRlcy4NCj4+Pj4gDQo+Pj4+IFdpbGwgZG8gdGhhdCBh
bmQgcmVwb3J0IGJhY2suIFlvdSB3YW50IGZ1bGwgbG9nIG9yIG9ubHkgc29tZSB0eXBpY2FsDQo+
Pj4+IG9uZXM/IEZ1bGwgbG9nIHdvdWxkIGJlIGJpZywgaG93IHNoYWxsIEkgc2hhcmU/IA0KPj4+
IA0KPj4+IEkgZG9uJ3Qgd2FudCB0byBzZWUgdGhlIGxvZy4gSXQnbGwgYmUgaHVnZSAtIEkgcmVn
dWxhcmx5IGdlbmVyYXRlDQo+Pj4gdHJhY2VzIGNvbnRhaW5pbmcgZ2lnYWJ5dGVzIG9mIGxvZyBh
Y2NvdW50aW5nIHRyYWNlcyBsaWtlIHRoaXMgZnJvbQ0KPj4+IGEgc2luZ2xlIHdvcmtsb2FkLg0K
Pj4+IA0KPj4+IFdoYXQgSSdtIGFza2luZyB5b3UgdG8gZG8gaXMgcnVuIHRoZSB0cmFjaW5nIGFu
ZCB0aGVuIHBvc3QgcHJvY2Vzcw0KPj4+IHRoZSB2YWx1ZXMgZnJvbSB0aGUgdHJhY2UgdG8gZGV0
ZXJtaW5lIHdoYXQgb3BlcmF0aW9uIGlzIHVzaW5nIG1vcmUNCj4+PiBzcGFjZSB0aGFuIGlzIGJl
aW5nIGZyZWVkIGJhY2sgdG8gdGhlIGxvZy4NCj4+PiANCj4+PiBJIGdlbmVyYWxseSBkbyB0aGlz
IHdpdGggZ3JlcCwgYXdrIGFuZCBzZWQuIHNvbWUgcGVvcGxlIHVzZSBweXRob24NCj4+PiBvciBw
ZXJsLiBCdXQgZWl0aGVyIHdheSBpdCdzIGEgKmxvdCogb2Ygd29yayAtIGluIHRoZSBwYXN0IEkg
aGF2ZQ0KPj4+IHNwZW50IF93ZWVrc18gb24gdHJhY2UgYW5hbHlzaXMgdG8gZmluZCBhIDQgYnl0
ZSBsZWFrIGluIHRoZSBsb2cNCj4+PiBzcGFjZSBhY2NvdW50aW5nLiBET2luZyB0aGluZ3MgbGlr
ZSBncmFwaGluZyB0aGUgaGVhZCwgdGFpbCBhbmQgZ3JhbnQNCj4+PiBzcGFjZXMgb3ZlciB0aW1l
IHRlbmQgdG8gc2hvdyBpZiB0aGlzIGlzIGEgZ3JhZHVhbCBsZWFrIHZlcnN1cyBhDQo+Pj4gc3Vk
ZGVuIHN0ZXAgY2hhbmdlLiBJZiBpdCdzIGEgc3VkZGVuIHN0ZXAgY2hhbmdlLCB0aGVuIHlvdSBj
YW4NCj4+PiBpc29sYXRlIGl0IGluIHRoZSB0cmFjZSBhbmQgd29yayBvdXQgd2hhdCBoYXBwZW5l
ZC4gSWYgaXQncyBhDQo+Pj4gZ3JhZHVhbCBjaGFuZ2UsIHRoZW4geW91IG5lZWQgdG8gc3RhcnQg
bG9va2luZyBmb3IgYWNjb3VudGluZw0KPj4+IGRpc2NyZXBhbmNpZXMuLi4NCj4+PiANCj4+PiBl
LmcuIGEgdHJhbnNhY3Rpb24gcmVjb3JkcyAzMiBieXRlcyB1c2VkIGluIHRoZSBpdGVtLCBzbyBp
dCByZWxlYXNlcw0KPj4+IHRfdW5pdCAtIDMyIGJ5dGVzIGF0IGNvbW1pdC4gSG93ZXZlciwgdGhl
IENJTCBtYXkgdGhlbiBvbmx5IHRyYWNrIDI4DQo+Pj4gYnl0ZXMgb2Ygc3BhY2UgZm9yIHRoZSBp
dGVtIGluIHRoZSBqb3VybmFsIGFuZCB3ZSBsZWFrIDQgYnl0ZXMgb2YNCj4+PiByZXNlcnZhdGlv
biBvbiBldmVyeSBvbiBvZiB0aG9zZSBpdGVtcyBjb21taXR0ZWQuDQo+Pj4gDQo+Pj4gVGhlc2Ug
c29ydHMgb2YgbGVha3MgdHlwaWNhbGx5IG9ubHkgYWRkIHVwIHRvIGJlaW5nIHNvbWV0aGlnbg0K
Pj4+IHNpZ25pZmljYW50IGluIHNpdHVhdGlvbnMgd2hlcmUgdGhlIGxvZyBpcyBmbG9vZGVkIHdp
dGggdGlueSBpbm9kZQ0KPj4+IHRpbWVzdGFtcCBjaGFuZ2VzIC0gNCBieXRlcyBpcGVyIGl0ZW0g
ZG9lc24ndCByZWFsbHkgbWF0dGVyIHdoZW4geW91DQo+Pj4gb25seSBoYXZlIGEgZmV3IHRob3Vz
YW5kIGl0ZW1zIGluIHRoZSBsb2csIGJ1dCB3aGVuIHlvdSBoYXZlDQo+Pj4gaHVuZHJlZHMgb2Yg
dGhvdXNhbmRzIG9mIHRpbnkgaXRlbXMgaW4gdGhlIGxvZy4uLg0KPj4+IA0KPj4gDQo+PiBPSy4g
d2lsbCB3b3JrIG1vcmUgb24gdGhpcy4NCj4+ICMgSSBhbSBnb2luZyB0byBzdGFydCBhIHR3by13
ZWVrIHZhY2F0aW9uLCBhbmQgd2lsbCB0aGVuIGNvbnRpbnVlIG9uIHRoaXMgd2hlbiBiYWNrLg0K
Pj4gDQo+PiB0aGFua3MsDQo+PiB3ZW5nYW5nDQo+IA0KPiANCg0K
