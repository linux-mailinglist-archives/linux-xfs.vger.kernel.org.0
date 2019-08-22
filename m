Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F0D98D1B
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2019 10:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbfHVIM1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Aug 2019 04:12:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732043AbfHVIM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 04:12:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7M89D3w092228;
        Thu, 22 Aug 2019 08:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=s6KN7n7wkiNHTz781fv1oKcr9eZQGtOISMDsPqy3ymQ=;
 b=ANhJW+v28SWzBNlNfDsbjycGnBonf7D7p/r/wJWQ1wvnMwnYCy5OCHIjxogBEY0+P6KR
 IlCOFKI2PBPstULr+daaouDQDz5JdrdpnaJtkiMOV+O06OSWLj5jjHXyS+p9d9JyirEC
 JAKK0U7BYTcL5891CU6dXOTExay5CsWRjyUoExGPKFR0EzFCRso/xg3rXnpaUsOxsNkl
 UXCtUuT/ontlARDj4qNGQApzlnHP9BW3/9SWwg8XIrcKkrZTGs/pFvG2T2rnBpePdtxe
 Sq9oWmpv5pn35QBWO7cjbycwdhpHKEE/d6S5S40MEeNoJac5zTqrk0qiYAukSvz93c+p dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ue9hpuhvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 08:12:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7M88dgY148864;
        Thu, 22 Aug 2019 08:12:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uh83pqfy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 08:12:01 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7M8C0Ii007220;
        Thu, 22 Aug 2019 08:12:00 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 08:11:59 +0000
Date:   Thu, 22 Aug 2019 11:11:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: Use BUG_ON rather than BUG() to remove unreachable
 code
Message-ID: <20190822081153.GG4451@kadam>
References: <20190822062320.GA35267@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822062320.GA35267@LGEARND20B15>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=844
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=915 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220089
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Depending on the config BUG() might be a no-op.  Outside of filesystems
everyone ignores that and crashes ungracefully, but in filesystems they
don't want to risk corrupting your files.

regards,
dan carpenter

