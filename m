Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE81C3AD571
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Jun 2021 00:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhFRWxz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 18 Jun 2021 18:53:55 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49904 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233892AbhFRWxz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 18:53:55 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 18426104433C;
        Sat, 19 Jun 2021 08:51:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1luNKw-00ELnq-I0; Sat, 19 Jun 2021 08:51:42 +1000
Date:   Sat, 19 Jun 2021 08:51:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: log write cleanups
Message-ID: <20210618225142.GN664593@dread.disaster.area>
References: <20210616163212.1480297-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-1-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=ZpT5fmD6inDxu0QeJakA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:04PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up a few loose ends that I noticed while reviewing
> the recent log rework.

This is all going to have to be rebased once I fix all the current
problems with the log code we are hitting.

In the mean time, can we focus on sorting out the current
correctness issues rather than largely cosmetic changes to the log
code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
