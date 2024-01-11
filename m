Return-Path: <linux-xfs+bounces-2715-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB9C82A727
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jan 2024 06:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EABA42862D2
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jan 2024 05:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B803539D;
	Thu, 11 Jan 2024 05:03:05 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004DA4693;
	Thu, 11 Jan 2024 05:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2AD3D68CFE; Thu, 11 Jan 2024 06:02:57 +0100 (CET)
Date: Thu, 11 Jan 2024 06:02:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
	kbusch@kernel.org, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ming.lei@redhat.com, bvanassche@acm.org,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v2 00/16] block atomic writes
Message-ID: <20240111050257.GA4457@lst.de>
References: <20231219051456.GB3964019@frogsfrogsfrogs> <20231219052121.GA338@lst.de> <76c85021-dd9e-49e3-80e3-25a17c7ca455@oracle.com> <20231219151759.GA4468@lst.de> <fff50006-ccd2-4944-ba32-84cbb2dbd1f4@oracle.com> <20231221065031.GA25778@lst.de> <73d03703-6c57-424a-80ea-965e636c34d6@oracle.com> <ZZ3Q4GPrKYo91NQ0@dread.disaster.area> <20240110091929.GA31003@lst.de> <20240111014056.GL722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111014056.GL722975@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 10, 2024 at 05:40:56PM -0800, Darrick J. Wong wrote:
> struct statx statx;
> struct fsxattr fsxattr;
> int fd = open('/foofile', O_RDWR | O_DIRECT);
> 
> ioctl(fd, FS_IOC_GETXATTR, &fsxattr);
> 
> fsxattr.fsx_xflags |= FS_XFLAG_FORCEALIGN | FS_XFLAG_WRITE_ATOMIC;
> fsxattr.fsx_extsize = 16384; /* only for hardware no-tears writes */
> 
> ioctl(fd, FS_IOC_SETXATTR, &fsxattr);
> 
> statx(fd, "", AT_EMPTY_PATH, STATX_ALL | STATX_WRITE_ATOMIC, &statx);
> 
> if (statx.stx_atomic_write_unit_max >= 16384) {
> 	pwrite(fd, &iov, 1, 0, RWF_SYNC | RWF_ATOMIC);
> 	printf("HAPPY DANCE\n");
> }

I think this still needs a check if the fs needs alignment for
atomic writes at all. i.e.

struct statx statx;
struct fsxattr fsxattr;
int fd = open('/foofile', O_RDWR | O_DIRECT);

ioctl(fd, FS_IOC_GETXATTR, &fsxattr);
statx(fd, "", AT_EMPTY_PATH, STATX_ALL | STATX_WRITE_ATOMIC, &statx);
if (statx.stx_atomic_write_unit_max < 16384) {
	bailout();
}

fsxattr.fsx_xflags |= FS_XFLAG_WRITE_ATOMIC;
if (statx.stx_atomic_write_alignment) {
	fsxattr.fsx_xflags |= FS_XFLAG_FORCEALIGN;
	fsxattr.fsx_extsize = 16384; /* only for hardware no-tears writes */
}
if (ioctl(fd, FS_IOC_SETXATTR, &fsxattr) < 1) {
	bailout();
}

pwrite(fd, &iov, 1, 0, RWF_SYNC | RWF_ATOMIC);
printf("HAPPY DANCE\n");

