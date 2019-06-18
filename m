Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1D44A4D7
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 17:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbfFRPL5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 11:11:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfFRPL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 11:11:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IF3WPB044326;
        Tue, 18 Jun 2019 15:11:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=2Yq8+cQB5znSe56t3dq+SiSYqad96gOk73cTcRoWfiU=;
 b=bFXEq4Soz6g29QUnMTNifH6nEFFx0TSaBYFQUB0MoMFVsrYpcWjeUIVgBYpWghDwYMzb
 qKfPK+hNfsjXRLWCaSAdz5HJOlXYk8YL/hCsK0N5ne1Ay5kseHm/q9ctpB/AGfSkUV5h
 1W/Idj7orxfx4GiVMHpMC4AzNHAwqsnly3KAODMLQOgPrIQbyUbdO59Rtbfe4uD9oMAX
 oIiN++lGru9lYgBYle12lfThk9b6956j5oc8A9jlscZcGyi2BqoqV3Jy32V0Fvly7bN9
 Q6GirDxW48kDg+dnBsWgFVksK6XBL0RCrngd0TOCNqPDjnfcYL8NgaVhRMok8I5LEvBF pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t4rmp5493-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:11:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFBBpx016764;
        Tue, 18 Jun 2019 15:11:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2t5cpe3twj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:11:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IFBo5b027837;
        Tue, 18 Jun 2019 15:11:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 08:11:50 -0700
Date:   Tue, 18 Jun 2019 08:11:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190618151144.GB5387@magnolia>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
 <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
 <20190618150242.GA4576@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618150242.GA4576@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 11:02:42AM -0400, Theodore Ts'o wrote:
> On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
> > On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > >
> > > Would you mind updating sha1 after it get merged to Linus tree?
> > >
> > > That would be helpful for people tracking this issue.
> > >
> > 
> > This is the commit id in linux-next and expected to stay the same
> > when the fix is merged to Linus tree for 5.3.
> 
> When I talked to Darrick last week, that was *not* the sense I got
> from him.  It's not necessarily guaranteed to be stable just yet...

Darrick hasn't gotten any complaints about the copy-file-range-fixes
branch (which has been in for-next for a week now), so he thinks that
commit id (a31713517dac) should be stable from here on out.

(Note that doesn't guarantee that Linus will pull said branch...)

--D

>      	   	    			   - Ted
