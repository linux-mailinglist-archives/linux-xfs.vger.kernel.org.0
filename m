Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A03B161D4F
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 23:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgBQW3e (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 17:29:34 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50165 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbgBQW3e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 17:29:34 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 655E17E9E20;
        Tue, 18 Feb 2020 09:29:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3otK-0003Zo-Ad; Tue, 18 Feb 2020 09:29:26 +1100
Date:   Tue, 18 Feb 2020 09:29:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 07/31] xfs: remove the name == NULL check from
 xfs_attr_args_init
Message-ID: <20200217222926.GL10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-8-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=eQSyFTfABt1POfwOF-YA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:33PM +0100, Christoph Hellwig wrote:
> All callers provide a valid name pointer, remove the redundant check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
