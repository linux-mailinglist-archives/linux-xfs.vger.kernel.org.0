Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D00151386
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2020 00:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgBCXzG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Feb 2020 18:55:06 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54979 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726287AbgBCXzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 18:55:06 -0500
Received: from dread.disaster.area (pa49-181-161-120.pa.nsw.optusnet.com.au [49.181.161.120])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DC70C7EA77F;
        Tue,  4 Feb 2020 10:55:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iylYT-0006i9-WD; Tue, 04 Feb 2020 10:55:02 +1100
Date:   Tue, 4 Feb 2020 10:55:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alan Latteri <alan@instinctualsoftware.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: su & sw for HW-RAID60
Message-ID: <20200203235501.GJ20628@dread.disaster.area>
References: <2CE21042-5F18-4642-BF48-AF8416FB9199@instinctualsoftware.com>
 <20200203225914.GB20628@dread.disaster.area>
 <03E9DDCF-9395-4E8A-A228-E8E5B004B111@instinctualsoftware.com>
 <B41F5F0B-1A6F-4089-8AC3-F3A39830CDA7@instinctualsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B41F5F0B-1A6F-4089-8AC3-F3A39830CDA7@instinctualsoftware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=SkgQWeG3jiSQFIjTo4+liA==:117 a=SkgQWeG3jiSQFIjTo4+liA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=6dIwrxDvgsjrXqbKbHYA:9 a=QEXdDO2ut3YA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 03, 2020 at 03:12:06PM -0800, Alan Latteri wrote:
> I should have read your response more thoroughly as you say exactly that, “behaves as a single disk”.
> 
> Here is the output from the mkfs.xfs command.  Not sure if those warning indicate any harm.
> 
> [root@chwumbo ~]# mkfs.xfs -f -d su=2560k,sw=5 /dev/chwumbo/data
> mkfs.xfs: Specified data stripe unit 5120 is not the same as the volume stripe unit 8192
> mkfs.xfs: Specified data stripe width 25600 is not the same as the volume stripe width 16384

What is /dev/chwumbo/data? It's reporting that it is a su=4M,sw=2
device, not a device with the physical characteristics you
described.

If it's LVM, it needs to be configured to align to the underlying
storage as well (i.e. 2560kB allocation units and alignment) so that
it doesn't cause the filesystem to be misaligned on the disks....

> meta-data=/dev/chwumbo/data      isize=512    agcount=728, agsize=268434560 blks
>          		=                       sectsz=4096  attr=2, projid32bit=1
>         		 =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          		 =                       reflink=1
> data    		 =                       bsize=4096   blocks=195316939776, imaxpct=1
>          		 =                       sunit=640    swidth=3200 blks
> naming  		 =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      		 =internal log           bsize=4096   blocks=521728, version=2
>         		 =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime 		 =none                   extsz=4096   blocks=0, rtextents=0

Otherwise that looks like a normal 728TB filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
