Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218AF119917
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Dec 2019 22:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLJVmn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Dec 2019 16:42:43 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50636 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727528AbfLJVmm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 16:42:42 -0500
Received: from dread.disaster.area (pa49-195-139-249.pa.nsw.optusnet.com.au [49.195.139.249])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B877A3A2AEE;
        Wed, 11 Dec 2019 08:42:37 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ienHB-0005YB-5U; Wed, 11 Dec 2019 08:42:37 +1100
Date:   Wed, 11 Dec 2019 08:42:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191210214237.GC19256@dread.disaster.area>
References: <20191210114807.161927-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210114807.161927-1-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=KoypXv6BqLCQNZUs2nCMWg==:117 a=KoypXv6BqLCQNZUs2nCMWg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=2JpbOsn2kNieY1kDmUgA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 10, 2019 at 12:48:07PM +0100, Pavel Reichl wrote:
> Some users are not happy about the BLKDISCARD taking too long and at the same
> time not being informed about that - so they think that the command actually
> hung.
> 
> This commit changes code so that progress reporting is possible and also typing
> the ^C will cancel the ongoing BLKDISCARD.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks fine to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
