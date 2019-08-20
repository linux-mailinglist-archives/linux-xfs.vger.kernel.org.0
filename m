Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2369595728
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Aug 2019 08:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfHTGOb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Aug 2019 02:14:31 -0400
Received: from verein.lst.de ([213.95.11.211]:53920 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbfHTGOb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 02:14:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3D98168B05; Tue, 20 Aug 2019 08:14:27 +0200 (CEST)
Date:   Tue, 20 Aug 2019 08:14:26 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190820061426.GA28042@lst.de>
References: <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de> <20190818173426.GA32311@lst.de> <20190819000831.GX6129@dread.disaster.area> <20190819034948.GA14261@lst.de> <20190819041132.GA14492@lst.de> <20190819042259.GZ6129@dread.disaster.area> <20190819042905.GA15613@lst.de> <20190819044012.GA15800@lst.de> <20190819053122.GK7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819053122.GK7777@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 03:31:22PM +1000, Dave Chinner wrote:
> But I'm not so sure that's all there is to it. I turned KASAN on and
> it works for the first few mkfs/mount cycles, then a mount basically
> pegs a CPU and it's spending most of it's time inside KASAN
> accouting code like this:

Did that KASAN spat lead anywhere?  I've done some KASAN runs now and
I've not seen anything yet after running mkfs/mount/umount in a loop.
