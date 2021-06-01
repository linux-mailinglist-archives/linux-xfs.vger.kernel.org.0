Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E19D396A19
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Jun 2021 01:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaXfa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 May 2021 19:35:30 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:35859 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhEaXfa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 19:35:30 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id BABBF1AF744;
        Tue,  1 Jun 2021 09:33:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lnrPn-007VKU-77; Tue, 01 Jun 2021 09:33:47 +1000
Date:   Tue, 1 Jun 2021 09:33:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/3] xfs: clean up open-coded fs block unit conversions
Message-ID: <20210531233347.GV664593@dread.disaster.area>
References: <162250083252.490289.17618066691063888710.stgit@locust>
 <162250084368.490289.286869347542521014.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162250084368.490289.286869347542521014.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=M8Uuf8cD9Hj3GNqrQ9YA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:40:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace some open-coded fs block unit conversions with the standard
> conversion macro.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
