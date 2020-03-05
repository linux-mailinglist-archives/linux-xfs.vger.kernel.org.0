Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58D0179DD1
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2020 03:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgCEC3J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 21:29:09 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54894 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbgCEC3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 21:29:09 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 19BFF3A29FD;
        Thu,  5 Mar 2020 13:29:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9gG1-0006Hv-8g; Thu, 05 Mar 2020 13:29:05 +1100
Date:   Thu, 5 Mar 2020 13:29:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: rename btree cursur private btree member flags
Message-ID: <20200305022905.GG10776@dread.disaster.area>
References: <20200305014537.11236-1-david@fromorbit.com>
 <20200305014537.11236-5-david@fromorbit.com>
 <20200305020804.GO8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305020804.GO8045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=J90htp9cnXotMGsvRUUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:08:04PM -0800, Darrick J. Wong wrote:
> On Thu, Mar 05, 2020 at 12:45:34PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > BPRV is not longer appropriate because bc_private is going away.
> > Script:
> > 
> > $ sed -i 's/BTCUR_BPRV/BC_BT/g' fs/xfs/*[ch] fs/xfs/*/*[ch]
> 
> I kinda hate the name though... BTCUR_BMBT?

Sure, that's simple enough to change. It's just a

s/BC_BT/BTCUR_BMBT/g

on the patch before I pop/push all the patches for a repost.

> (Also 'cursor' is misspelled in the subject line)

Fixed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
