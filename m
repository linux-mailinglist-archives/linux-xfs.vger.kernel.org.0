Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4811BAF
	for <lists+linux-xfs@lfdr.de>; Thu,  2 May 2019 16:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfEBOpA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 May 2019 10:45:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBOpA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 May 2019 10:45:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1496305B16F;
        Thu,  2 May 2019 14:45:00 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23E6A608A6;
        Thu,  2 May 2019 14:44:59 +0000 (UTC)
Subject: Re: [PATCH V2] xfs: change some error-less functions to void types
To:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
 <2a52ea5e-e056-244b-4d9b-04ed15d996fd@sandeen.net>
 <20190502121741.GB22716@bfoster>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <c73c4e8f-dafb-d216-3af8-28bf1f1aac60@redhat.com>
Date:   Thu, 2 May 2019 09:44:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502121741.GB22716@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 02 May 2019 14:45:00 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/2/19 7:17 AM, Brian Foster wrote:
>> -	return 0;
>> +	return;
> No need for return statements at the end of void functions. With that
> fixed up (here and throughout the rest of the patch):
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 

Oh, hah.  IR smart.  (was on autopilot...)  I'll send V3.

-Eric
