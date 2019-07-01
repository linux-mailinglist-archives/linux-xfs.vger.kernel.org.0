Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CD448C1
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 19:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfFMRLI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 13:11:08 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39852 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729161AbfFLWVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 18:21:00 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A1D253DB25E;
        Thu, 13 Jun 2019 08:20:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hbBb3-0003I9-UO; Thu, 13 Jun 2019 08:19:57 +1000
Date:   Thu, 13 Jun 2019 08:19:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alvin Zheng <Alvin@linux.alibaba.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "darrick.wong" <darrick.wong@oracle.com>,
        caspar <caspar@linux.alibaba.com>
Subject: Re: [PATCH xfsprogs manual] Inconsistency between the code and the
 manual page
Message-ID: <20190612221957.GF14363@dread.disaster.area>
References: <a8dbaa7f-f89c-8a78-1fc6-3626f6b3f873@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8dbaa7f-f89c-8a78-1fc6-3626f6b3f873@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=6NWEf4Fju2ZyfUYQPGUA:9 a=wPNLvfGTeEIA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 01:20:46PM +0800, Alvin Zheng wrote:
> Hi,
> 
> ��� The manual page of mkfs.xfs (xfsprogs-5.0.0) says "When specifying�
> parameters in units of sectors or filesystem blocks, the -s option or the -b
> option first needs to be added to the command line.� Failure to specify the
> size of the units will result in illegal value errors when parameters are
> quantified in those units". However, I read the code and found that if the
> size of the block and sector is not specified, the default size (block: 4k,
> sector: 512B) will be used. Therefore, the following commands can work
> normally in xfsprogs-5.0.0.
> 
> ���� mkfs.xfs -n size=2b /dev/vdc
> ���� mkfs.xfs -d agsize=8192b /dev/vdc
> 
> ��� So I think the manual of mkfs.xfs should be updated as follows. Any
> ideas?

The intent of the wording in the mkfs man page is "when using a
custom sector or block size, it must be specified before any
parameter that uses units of sector or block sizes." So just
removing the "it must be specified first" wording is incorrect
because mkfs should throw errors is it is not specified first.

> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c..45d7a84 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -115,9 +115,7 @@ When specifying parameters in units of sectors or
> filesystem blocks, the
> �.B \-s
> �option or the
> �.B \-b
> -option first needs to be added to the command line.
> -Failure to specify the size of the units will result in illegal value
> errors
> -when parameters are quantified in those units.
> +option can be used to specify the size of the sector or block. If the size
> of the block or sector is not specified, the default size (block: 4KiB,
> sector: 512B) will be used.

That's fine to remove.

> �.PP
> �Many feature options allow an optional argument of 0 or 1, to explicitly
> �disable or enable the functionality.
> @@ -136,10 +134,6 @@ The filesystem block size is specified with a
> �in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and
> the
> �maximum is 65536 (64 KiB).
> �.IP
> -To specify any options on the command line in units of filesystem blocks,
> this
> -option must be specified first so that the filesystem block size is
> -applied consistently to all options.

"If a non-default filesystem block size is specified, the option
must be specified before any options that use filesystem block size
units so that the non-default filesystem block size is applied
consistently to all options."

> -.IP
> �Although
> �.B mkfs.xfs
> �will accept any of these values and create a valid filesystem,
> @@ -894,10 +888,6 @@ is 512 bytes. The minimum value for sector size is
> �.I sector_size
> �must be a power of 2 size and cannot be made larger than the
> �filesystem block size.
> -.IP
> -To specify any options on the command line in units of sectors, this
> -option must be specified first so that the sector size is
> -applied consistently to all options.

Same wording as for the filesystem block size applies to sector
sizes as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
