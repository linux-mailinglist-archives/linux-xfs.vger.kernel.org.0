Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4094F272FA
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 01:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfEVX3D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 19:29:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51861 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726553AbfEVX3D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 May 2019 19:29:03 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C71EB43A3B1;
        Thu, 23 May 2019 09:29:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTafL-0004gp-7q; Thu, 23 May 2019 09:28:59 +1000
Date:   Thu, 23 May 2019 09:28:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190522232859.GK29573@dread.disaster.area>
References: <20190520161347.3044-1-hch@lst.de>
 <20190520161347.3044-15-hch@lst.de>
 <20190520233233.GF29573@dread.disaster.area>
 <20190521050943.GA29120@lst.de>
 <20190521222434.GH29573@dread.disaster.area>
 <20190522051214.GA19467@lst.de>
 <20190522061919.GJ29573@dread.disaster.area>
 <20190522173132.GA31394@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522173132.GA31394@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=JfrnYn6hAAAA:8 a=7-415B0cAAAA:8 a=iXrNYarUixIWIC-UhRQA:9
        a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 07:31:32PM +0200, Christoph Hellwig wrote:
> Does this look fine to you?
> 
> http://git.infradead.org/users/hch/xfs.git/commitdiff/8d9600456c6674453dddd5bf36512658c39d7207

Yeah, that'll make it heaps easier to deal with. I'd rename "bp" in
that patch to something like "bufp" so it's not easily confused with
a xfs_buf bp, but otherwise it looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
