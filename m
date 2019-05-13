Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590271BF0D
	for <lists+linux-xfs@lfdr.de>; Mon, 13 May 2019 23:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfEMVTw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 May 2019 17:19:52 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56535 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbfEMVTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 May 2019 17:19:52 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AFEE8105EB10;
        Tue, 14 May 2019 07:19:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hQIMN-0007BW-GU; Tue, 14 May 2019 07:19:47 +1000
Date:   Tue, 14 May 2019 07:19:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Tim Smith <tim.smith@vaultcloud.com.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Message-ID: <20190513211947.GR29573@dread.disaster.area>
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=bCehgFow564ZMDg6M0cA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 13, 2019 at 11:45:26AM +1000, Tim Smith wrote:
> Hey guys,
> 
> We've got a bunch of hosts with multiple spinning disks providing file
> server duties with xfs.
> 
> Some of the filesystems will go into a state where they report
> negative used space -  e.g. available is greater than total.
> 
> This appears to be purely cosmetic, as we can still write data to (and
> read from) the filesystem, but it throws out our reporting data.
> 
> We can (temporarily) fix the issue by unmounting and running
> `xfs_repair` on the filesystem, but it soon reoccurs.
....
> Example of a 'good' filesystem on the host:
.....
> fdblocks = 459388955
> 
> Example of a 'bad' filesystem on the host:
.....
> fdblocks = 4733263928


  decimal	 hex
 459388955	 1b61b7cb
4733263928	11a1fdfe8
                ^
		Single bit is wrong in the free block count.

IOWs, I'd say there's single bit errors happening somewhere in your
system. Whether it be memory corruption, machines being rowhammered,
uncorrected storage media errors, etc I have no idea. But it seems
suspicious that the free block count is almost exactly 0x100000000
out....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
