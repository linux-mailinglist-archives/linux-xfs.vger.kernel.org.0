Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A21107578
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Nov 2019 17:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKVQLR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 Nov 2019 11:11:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKVQLR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 11:11:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMG4MJZ001531;
        Fri, 22 Nov 2019 16:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=1fOD86jxsrF5BrezisDsSvfd2EGC9eeWf+2Tqmc/5HI=;
 b=h9dx3NBX4mooDs1nNHGV86b4f1AOZXU2yNKX46y25TAnTwDoeLBYCBiQPPrPmu7+oct4
 I8xbmPINHPn9AmD0qknFkcEsv9JHl+6VR01CzKjFRLaWFDxdXP8DIfnYHLGgWEqYZ6tI
 YdBYWQzf5/fYKNaKf7Qw85e5ZD5rR74LzVSRx3efS6yGe2M/VI9wmty5Mu7DDIpDJet5
 geusqYhLl2YmqeU+mo/s5mOlujPotlBUQFn8khriUILiM3EWVrEL88otgtwW0t25ZZ5D
 ksiTf2KJ4fkHDh/afYxlGz15w5Yp73WPo66n81WfQIho9H6c6vI22LwOftIK0HivsQan +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wa92qbhju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:11:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAMG4863018613;
        Fri, 22 Nov 2019 16:11:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wegqrfy2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Nov 2019 16:11:13 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAMGBC03024437;
        Fri, 22 Nov 2019 16:11:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Nov 2019 08:11:12 -0800
Date:   Fri, 22 Nov 2019 08:11:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191122161111.GF6219@magnolia>
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
 <20191114210000.GL6219@magnolia>
 <20191115142055.asqudktld7eblfea@orion>
 <20191115172322.GO6219@magnolia>
 <20191118083008.ttbikkwmrjy4k322@orion>
 <20191121054352.GW6219@magnolia>
 <20191122085033.nluuuvomf64pu3qx@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122085033.nluuuvomf64pu3qx@orion>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911220138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911220138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 09:50:33AM +0100, Carlos Maiolino wrote:
> Hi Darrick.
> 
> 
> > > > 
> > > > Sure, but I'll believe that when I see it.  And given that Christoph
> > > > Lameter seems totally opposed to the idea, I think we should keep our
> > > > silly wrapper for a while to see if they don't accidentally revert it or
> > > > something.
> > > > 
> > > 
> > > Sure, I don't have any plans to do it now in this series or in a very near
> > > future, I just used the email to share the idea :P
> > 
> > Eh, well, FWIW I took a second look at all the kvfree/kfree and decided
> > that the usage was correct.  For future reference, please do the
> > straight change as one patch and straighten out the usages as a separate
> > patch.
> > 
> 
> I'm not sure what you meant by 'straight change' and 'straighten out'.
> 
> Do you mean to do send a single patch with only the changes made by the
> 'find&replace' command, followed up by a kfree() -> kvfree() where appropriate?

Er, the opposite in this case -- Patch 1 replaces all the kmem_free
calls with kvfree calls (because that's what kmem_free did).  Patch 2
then changes the kvfree calls to kfree calls, but only for the cases
where we kmalloc'd the memory.

--D

> Cheers.
> 
> > In any case it seemed to test ok over the weekend (and still seems ok
> > with your series from today), so...
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> 
> > --D
> > 
> > > Thanks for the review.
> > > 
> > > -- 
> > > Carlos
> > > 
> > 
> 
> -- 
> Carlos
> 
