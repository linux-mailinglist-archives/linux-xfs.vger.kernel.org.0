Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 734A511066
	for <lists+linux-xfs@lfdr.de>; Thu,  2 May 2019 01:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfEAXtn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 May 2019 19:49:43 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59693 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfEAXtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 May 2019 19:49:43 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D89AD439EE1;
        Thu,  2 May 2019 09:49:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hLyyr-0005TG-0p; Thu, 02 May 2019 09:49:41 +1000
Date:   Thu, 2 May 2019 09:49:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfs: change some error-less functions to void types
Message-ID: <20190501234939.GK29573@dread.disaster.area>
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
 <2a52ea5e-e056-244b-4d9b-04ed15d996fd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a52ea5e-e056-244b-4d9b-04ed15d996fd@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=UJetJGXy c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=zufj7rycC16unmZ_Xx0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 01, 2019 at 05:20:52PM -0500, Eric Sandeen wrote:
> There are several functions which have no opportunity to retun
							   return

> an error, and don't contain any ASSERTs which could be argued
> to be better constructed as error cases.  So, make them voids
> to simplify the callers.

Does it make the code smaller? :)

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
