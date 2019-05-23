Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD5F28DC5
	for <lists+linux-xfs@lfdr.de>; Fri, 24 May 2019 01:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbfEWXbp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 19:31:45 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36008 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfEWXbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 19:31:45 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8827ED5AD;
        Fri, 24 May 2019 09:31:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTxBV-0005Mq-2h; Fri, 24 May 2019 09:31:41 +1000
Date:   Fri, 24 May 2019 09:31:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/20] xfs: make use of the l_targ field in struct xlog
Message-ID: <20190523233141.GY29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-13-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=fpwgGjX-GLS2HhmsyhcA:9
        a=CjuIK1q_8ugA:10 a=DBeEp3iAzaEA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:34PM +0200, Christoph Hellwig wrote:
> Use the slightly shorter way to get at the buftarg for the log device
> wherever we can in the log and log recovery code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
