Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7C1CF96A
	for <lists+linux-xfs@lfdr.de>; Tue, 12 May 2020 17:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgELPjH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 May 2020 11:39:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgELPjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 11:39:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CFXNFg135899;
        Tue, 12 May 2020 15:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JUEO9ZoXxB2BoFtGpQagUthbsxKVIf4yyUgkHqt1WSE=;
 b=srdKymy1gt2f8jrKEo+wbhwSc3KX3lX2juAbnlxVWF1eCcNzbiKLEICHTRn0BTr6MM/8
 IFPzA0ddIPVa9QSRKATmvWp3u/H1Y3dCBZWK1d33hf3LdOTqTUR961qz5Chacna/e+L+
 LEf2fphmsDtY60S2Cfl7J0I+0Y2Jia+ycLDoOmplXITcQN77ulMw+yDvjYjpzx6FyFi8
 ZhXUTz5ifhEqkQ0I71zZG3TxSTFSGNEKhw5GMkRGO0QopxMvwOC4pBHhhHISpDr7VNpn
 h6WmDauPP/LhSpp6vfEGEtYGkv+N5OGfpyXY69OsjyNWiX5nPxJmfHF1eKBdBJD/Z84s hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30x3mburwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 15:39:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CFYOgL160245;
        Tue, 12 May 2020 15:38:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30x69tf292-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 15:38:59 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CFcuww024852;
        Tue, 12 May 2020 15:38:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 08:38:56 -0700
Date:   Tue, 12 May 2020 08:38:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: use XFS_IFORK_BOFF xchk_bmap_check_rmaps
Message-ID: <20200512153854.GC6714@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-2-hch@lst.de>
 <2615851.ejxhajbSum@garuda>
 <20200512153132.GE37029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512153132.GE37029@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=1 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 11:31:32AM -0400, Brian Foster wrote:
> On Mon, May 11, 2020 at 05:10:04PM +0530, Chandan Babu R wrote:
> > On Sunday 10 May 2020 12:53:59 PM IST Christoph Hellwig wrote:
> > > XFS_IFORK_Q is to be used in boolean context, not for a size.  This
> > > doesn't make a difference in practice as size is only checked for
> > > 0, but this keeps the logic sane.
> > >
> > 
> > Wouldn't XFS_IFORK_ASIZE() be a better fit since it gives the space used by the
> > attr fork inside an inode's literal area?
> > 
> 
> I had the same thought. It's not clear to me what size is really
> supposed to be between the file size for a data fork and fork offset for
> the attr fork. I was also wondering if this should use
> XFS_IFORK_DSIZE(), but that won't be conditional based on population of
> the fork. At the same time, I don't think i_size != 0 necessarily
> correlates with the existence of blocks. The file could be completely
> sparse or could have any number of post-eof preallocated extents.

TBH I should have made that variable "bool empty" or something.

case XFS_DATA_FORK:
	empty = i_size_read() == 0;

case XFS_ATTR_FORK:
	empty = !XFS_IFORK_Q();

default:
	empty = true;

if ((is not btree) && (empty || nextents > 0))
	return 0;

--D

> Brian
> 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/scrub/bmap.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > index add8598eacd5d..283424d6d2bb6 100644
> > > --- a/fs/xfs/scrub/bmap.c
> > > +++ b/fs/xfs/scrub/bmap.c
> > > @@ -591,7 +591,7 @@ xchk_bmap_check_rmaps(
> > >  		size = i_size_read(VFS_I(sc->ip));
> > >  		break;
> > >  	case XFS_ATTR_FORK:
> > > -		size = XFS_IFORK_Q(sc->ip);
> > > +		size = XFS_IFORK_BOFF(sc->ip);
> > >  		break;
> > >  	default:
> > >  		size = 0;
> > > 
> > 
> > 
> > -- 
> > chandan
> > 
> > 
> > 
> 
