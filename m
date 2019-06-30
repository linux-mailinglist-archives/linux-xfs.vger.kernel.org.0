Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C84D5B074
	for <lists+linux-xfs@lfdr.de>; Sun, 30 Jun 2019 17:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF3PkF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Jun 2019 11:40:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF3PkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 11:40:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5UFcUXl106954;
        Sun, 30 Jun 2019 15:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=66KVBiS6h7cPhy7jKAPsyQJzbSkXnPYann8q71lQcws=;
 b=RcKHZ7CG54AFdYJ0M7DJkuW6HNWXiH9qkrUuvItR4825+9USlcsjXhmSKemLPqMpRAEu
 rXLpEiPIkB9+cUiqDGZnB334uWTj/a/q7NjCBiZfifFqxqZoGHwUS9JyEHpiCcTvp8em
 1QkulR7ZgPfw2AKw0hXKzRI1+iqdcN8XTsuQQh6WjqC/VEtFtCA0ZgoyUlA0V408JxiI
 6tMzMkmw9UfTYvyQRqLvjajLh33M3hbCHMnR5HsOhVZdjg/JA0Atx/FOmuWzN0qUp+BB
 jNk1S4qypnlwJU24HYEyRErnl0LTT63A165xH/1TDP9rigup0uTAbF/1YsFYkuxZOL+w cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61dt5rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Jun 2019 15:40:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5UFbVHX034255;
        Sun, 30 Jun 2019 15:39:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tebktbej5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Jun 2019 15:39:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5UFduoh026401;
        Sun, 30 Jun 2019 15:39:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Jun 2019 08:39:56 -0700
Date:   Sun, 30 Jun 2019 08:39:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>, Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Include 'xfs: speed up large directory modifications' in 5.3?
Message-ID: <20190630153955.GF1404256@magnolia>
References: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9304 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906300201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9304 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906300201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 30, 2019 at 01:28:09PM +0200, Holger Hoffstätte wrote:
> Hi,
> 
> I have been running with Dave's series for faster directory inserts since
> forever without any issues, and the last revision [1] still applies cleanly
> to current5.2-rc (not sure about xfs-next though).
> Any chance this can be included in 5.3? IMHO it would be a shame if this
> fell through the cracks again.
> 
> Thanks,
> Holger
> 
> [1] https://patchwork.kernel.org/project/xfs/list/?series=34713

Christoph reviewed most of the series, but it looked like he and Dave
went back and forth a bit on the second to last patch and Dave never
sent a v2 series or a request to just merge it as is, so I didn't take
any action.  Hey Dave, are you still working on a resubmission for this
series?

--D
