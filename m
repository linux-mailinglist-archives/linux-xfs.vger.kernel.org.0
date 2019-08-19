Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E2591BB9
	for <lists+linux-xfs@lfdr.de>; Mon, 19 Aug 2019 06:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfHSELg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 19 Aug 2019 00:11:36 -0400
Received: from verein.lst.de ([213.95.11.211]:44095 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfHSELg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 00:11:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EDEAE68B02; Mon, 19 Aug 2019 06:11:32 +0200 (CEST)
Date:   Mon, 19 Aug 2019 06:11:32 +0200
From:   "hch@lst.de" <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190819041132.GA14492@lst.de>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com> <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de> <20190818173426.GA32311@lst.de> <20190819000831.GX6129@dread.disaster.area> <20190819034948.GA14261@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819034948.GA14261@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 05:49:48AM +0200, hch@lst.de wrote:
> The fake pmem was create by the following kernel command line sniplet:
> "memmap=2000M!1024M,2000M!4096M" and my kernel config is attached.  I
> suspect you'll need CONFIG_SLUB to create the woes, but let me confirm
> that..

Yep, doesn't reproduce with CONFIG_SLAB.
