Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109388A705
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfHLT1I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:27:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLT1H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:27:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJEQOn113085;
        Mon, 12 Aug 2019 19:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZyJSaQGhQkr85spiLJBCMKEM8PHj72IpahzzVixUGA4=;
 b=cAXMk3NDpfJhyKvDBcpqegJTaqx/EaD7EyDUGH1HLsL9N13fJrV8agD0OANa/Zb7dZVZ
 hPgxAGxut2SC2NOJOZXedddlf3yegfpAnN8p5JuI0WMfJ1shPYtkR3F/6uzlF6FYI8tr
 XUU19T26v+tcRZBU1rwUw984q/IB3tAT/2KIz4dSdkUIeU/gaRH2frZufTPJEMkNrR7t
 WiUSEhL2T1vx52GohATw1sfmRtON4iLT3Gr3RkTL7hAn67q7AKz5XyUHYelPBzVzpWiQ
 3nRh+KFTg/hPltz3zx2efTxLKIVJVL6SPj1cMprmNN5+hH5PVRcf0/PRZP7w7mi2i1/Q JQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ZyJSaQGhQkr85spiLJBCMKEM8PHj72IpahzzVixUGA4=;
 b=BNgxD/OOeCW+BRfUBAzuSA7PsB6Tn0ZhliSXqWYPeV7jmBX5TVee1pvnVh746u1blic6
 Gu7D5tsuQ55tzPZn7dz6B0kykjofW33L+M9dPxhJNgJpHeoBa9jPl79YmN1Qc+KQTcwm
 xm7M8hANYEkVyF6Td4tetb7h7D87yqu+yCuhSX/QU0Clh9diyu2N+zLet2ZRM0eC2oEp
 qAHVM+ZZxdWTWx6j8Fvp+ebBIWXbDj2BAmQizaRHRHImPvx7YL1Wn9ztW+3eP4e7vfdW
 XHUIrrvAJzRK7hFN80FTO+yRY02yP1J2Pnwud+GpEhxcAcLmT7IKZqMqPhpMIHZpEUXQ kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u9pjq9msp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 19:26:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJCbnm137766;
        Mon, 12 Aug 2019 19:26:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u9k1vjuxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 19:26:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJQt3A013374;
        Mon, 12 Aug 2019 19:26:55 GMT
Received: from [192.168.1.9] (/174.18.98.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:26:55 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 00/18] Delayed Attributes
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190812081954.GA9484@infradead.org>
Message-ID: <1d0ff885-53a7-e29d-dda8-17017399aab5@oracle.com>
Date:   Mon, 12 Aug 2019 12:26:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812081954.GA9484@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=962
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/19 1:19 AM, Christoph Hellwig wrote:
> Btw, this seems like the right series to also look into our problem
> that large attributes are not updated transactionally.  We just do
> a synchronous write (xfs_bwrite) for them but don't include them
> in the transaction.  With the deferred operations and rolled
> transactions that should be fairly easy to fix.
> 
Ah, alrighty then.  I will add that into the cover letter next time as
another possible use case for it.  :-)

Thx!
Allison
