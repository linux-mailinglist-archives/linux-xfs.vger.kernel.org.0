Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4662539F0
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Aug 2020 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHZVvv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Aug 2020 17:51:51 -0400
Received: from sandeen.net ([63.231.237.45]:36414 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgHZVvv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Aug 2020 17:51:51 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 87D6DEF1;
        Wed, 26 Aug 2020 16:51:39 -0500 (CDT)
Subject: Re: [PATCH 1/3] build: add support for libinih for mkfs
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200826015634.3974785-1-david@fromorbit.com>
 <20200826015634.3974785-2-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <18ce951d-c209-9c60-3f6c-0c7989c587ae@sandeen.net>
Date:   Wed, 26 Aug 2020 16:51:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200826015634.3974785-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/25/20 8:56 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Need to make sure the library is present so we can build mkfs with
> config file support.

Can you add https://github.com/benhoyt/inih to doc/INSTALL as a
dependency?

(that's probably pretty out of date now anyway but it seems worth
documenting any new requirement)

-Eric
