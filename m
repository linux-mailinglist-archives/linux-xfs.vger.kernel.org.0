Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DC5222F06
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jul 2020 01:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgGPXcj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jul 2020 19:32:39 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39080 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726113AbgGPXcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 19:32:39 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C7F773A4164;
        Fri, 17 Jul 2020 09:32:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwDMg-0001MG-1N; Fri, 17 Jul 2020 09:32:34 +1000
Date:   Fri, 17 Jul 2020 09:32:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: drop the type parameter from xfs_dquot_verify
Message-ID: <20200716233234.GN2005@dread.disaster.area>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
 <159488192588.3813063.14434497860489645794.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159488192588.3813063.14434497860489645794.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=lloFehcQa8CKRPW5UqkA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 11:45:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_qm_reset_dqcounts (i.e. quotacheck) is the only xfs_dqblk_verify
> caller that actually knows the specific quota type that it's looking
> for.  Since everything else just pass in type==0 (including the buffer
> verifier), drop the parameter and open-code the check like
> xfs_dquot_from_disk already does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
