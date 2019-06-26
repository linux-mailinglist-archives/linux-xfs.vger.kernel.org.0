Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0156D55
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfFZPKi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 11:10:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZPKi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 11:10:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QF9TGg134986;
        Wed, 26 Jun 2019 15:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=nopMumzksuMU6iOAzNWBNzsat5daurPKAPNuPFMxi2s=;
 b=1bcZXHe85fZJ8XhSaMiXuLnEhzrvTyJmond8rojAW1O8gvr2HSwdTDRF4XwHBJpByKBF
 VcyVXbTbd8YpN8a6AdoaRfqg/F8pm6wfV+QKc1aVgKh1L+VPupaednRN0Zvi/E+ruqGL
 D4DvjYkNk/hg25p82IRequX85YP6PaUe2GDh6HQuUAMl2OV8ehNi+iE2uitiZ0+3RNfd
 7l+VOYokLGx8dzy14NY2DuNCC1tc/QB4b2XNqxFY6t3AX4l+xLeOYWo4gDt8TH0nXLjd
 gtgjtYcGBIPezHfqe+BdRqdHIu56PlxEG1+NNbD4nyeY6n+khPujgjyBhMSMl71Xz2Gq 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqjvsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 15:10:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QF9St5033435;
        Wed, 26 Jun 2019 15:10:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7cvm6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 15:10:00 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QF9xBB007263;
        Wed, 26 Jun 2019 15:09:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 08:09:59 -0700
Date:   Wed, 26 Jun 2019 08:09:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: xfs cgroup writeback support
Message-ID: <20190626150958.GB5171@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
 <20190625032527.GF1611011@magnolia>
 <20190625100532.GE1462@lst.de>
 <20190626055701.GA5171@magnolia>
 <20190626055732.GA23631@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626055732.GA23631@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 07:57:32AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 25, 2019 at 10:57:01PM -0700, Darrick J. Wong wrote:
> > That may be, but I don't want to merge this patchset only to find out
> > I've unleashed Pandora's box of untested cgroupwb hell... I /think/ they
> > fixed all those problems, but it didn't take all that long tracing the
> > blkg/blkcg object relationships for my brain to fall out. :/
> 
> c'mon.  We are adding handful of line patch to finally bring XFS in
> line with everyone else.  That doesn't mean we want to take over
> cgroup maintenance.

I didn't want us to take over maintenance of copy_file_range and the
remap ioctls either, but now look.  /me burns out on cleaning up new
features that haven't been adequately specified and tested and having to
retrofit sane behavior into existing userspace ABI; and I wouldn't be
shocked to hear Dave and Amir probably feel similarly.

<frown>

That said, I did go digging further into how cgroup writeback accounting
works and AFAICT the things people were complaining about in the last
three attempts to add cgroupwb support to xfs have been solved, so I
guess I'm fine with the series:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
