Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF9439467
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 20:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbfFGSeW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 14:34:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730978AbfFGSeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 14:34:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57ITMNN031647;
        Fri, 7 Jun 2019 18:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=QolDy22uOLtBFa3YAasmOe69CPUw0iodu68OQSiZ4/I=;
 b=EL5NpsBTmOzBK4E1TTYSBNZF7Fboir2lPBs3P9MB4V6Y3256Qpzxxnr4BOFbyOiMzcUZ
 CwqkHii0C92he+/EbdutialG4GKTZmUW4oRRIJ/lPjlzcJgPcKL+Cifhtqf6IVvUgmpk
 hvp7wIHAFB6YKYW0ZatlB++vzVLP+VOkjJ4HJ1/9Q0QkhKtA5yju32rU52FCj3UuO/1R
 j6h4KtcEFibA1RFLcaHJaDES9I03Dzc8ZpiEfor1GRQnUX87RLCTs7MJBGn7d2+1h8sd
 OzIwQcwBAu17liXQGF03DhAhVrH825UM4tiPJlDrcLdccLNRLN06eTaFAI59rlPQRk7a Tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugstyxkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 18:34:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57IXxrm045999;
        Fri, 7 Jun 2019 18:34:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2swngk5pdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 18:34:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x57IYB8s001900;
        Fri, 7 Jun 2019 18:34:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 11:34:11 -0700
Date:   Fri, 7 Jun 2019 11:34:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Documentation: xfs: Fix typo
Message-ID: <20190607183410.GF1871505@magnolia>
References: <20190509030549.2253-1-ruansy.fnst@cn.fujitsu.com>
 <20190607114415.32cb32dd@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190607114415.32cb32dd@lwn.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 07, 2019 at 11:44:15AM -0600, Jonathan Corbet wrote:
> On Thu, 9 May 2019 11:05:49 +0800
> Shiyang Ruan <ruansy.fnst@cn.fujitsu.com> wrote:
> 
> > In "Y+P" of this line, there are two non-ASCII characters(0xd9 0x8d)
> > following behind the 'Y'.  Shown as a small '=' under the '+' in VIM
> > and a '賺' in webpage[1].
> > 
> > I think it's a mistake and remove these strange characters.
> > 
> > [1]: https://www.kernel.org/doc/Documentation/filesystems/xfs-delayed-logging-design.txt
> > 
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> > ---
> >  Documentation/filesystems/xfs-delayed-logging-design.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/filesystems/xfs-delayed-logging-design.txt b/Documentation/filesystems/xfs-delayed-logging-design.txt
> > index 2ce36439c09f..9a6dd289b17b 100644
> > --- a/Documentation/filesystems/xfs-delayed-logging-design.txt
> > +++ b/Documentation/filesystems/xfs-delayed-logging-design.txt
> > @@ -34,7 +34,7 @@ transaction:
> >  	   D			A+B+C+D		X+n+m+o
> >  	    <object written to disk>
> >  	   E			   E		   Y (> X+n+m+o)
> > -	   F			  E+F		  Yٍ+p
> > +	   F			  E+F		  Y+p
> 
> OK, that does look funky, applied.
> 
> This patch probably should have been copied to the XFS list (added), even
> though get_maintainer.pl doesn't know that.

Yeah, it's "Y+p" not "Y<weird plusequals thing>p" in the xfs
documentation repo:

https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/design/XFS_Filesystem_Structure/delayed_logging.asciidoc

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

I doubt the value of maintaining duplicate copies of this document in
the kernel and the xfs documentation repo, and since the xfs docs and
kernel licences aren't compatible maybe we should withdraw one...

...but since Dave is the author I'm gonna punt to him.  IMHO either we
should claim responsibility for those files in MAINTAINERS or drop them.
:)

Thanks for the heads-up,
--D

> Thanks,
> 
> jon
