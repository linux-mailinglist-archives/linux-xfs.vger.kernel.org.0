Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F0138048
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 00:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfFFWIO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 18:08:14 -0400
Received: from sandeen.net ([63.231.237.45]:60530 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbfFFWIN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Jun 2019 18:08:13 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B7EEC2ADF;
        Thu,  6 Jun 2019 17:07:48 -0500 (CDT)
Subject: Re: [PATCH v2] xfs_restore: detect rtinherit on destination
To:     Dave Chinner <david@fromorbit.com>
Cc:     Sheena Artrip <sheenobu@fb.com>, sheena.artrip@gmail.com,
        linux-xfs@vger.kernel.org
References: <e6968aa2-a5ad-4964-2966-589486e4a251@sandeen.net>
 <20190606195724.2975689-1-sheenobu@fb.com>
 <f89a09b5-8a91-51e0-d869-039dbe9a7349@sandeen.net>
 <20190606215008.GA14308@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <4a03b347-1a71-857d-af9d-1d7eca00056a@sandeen.net>
Date:   Thu, 6 Jun 2019 17:08:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606215008.GA14308@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/6/19 4:50 PM, Dave Chinner wrote:
> On Thu, Jun 06, 2019 at 04:23:51PM -0500, Eric Sandeen wrote:
>> On 6/6/19 2:57 PM, Sheena Artrip wrote:
>>> When running xfs_restore with a non-rtdev dump,
>>> it will ignore any rtinherit flags on the destination
>>> and send I/O to the metadata region.
>>>
>>> Instead, detect rtinherit on the destination XFS fileystem root inode
>>> and use that to override the incoming inode flags.
>>>
>>> Original version of this patch missed some branches so multiple
>>> invocations of xfsrestore onto the same fs caused
>>> the rtinherit bit to get re-removed. There could be some
>>> additional edge cases in non-realtime to realtime workflows so
>>> the outstanding question would be: is it worth supporting?
>>>
>>> Changes in v2:
>>> * Changed root inode bulkstat to just ioctl to the destdir inode
>>
>> Thanks for that fixup (though comment still says "root" FWIW)
>>
>> Thinking about this some more, I'm really kind of wondering how this
>> should all be expected to work.  There are several scenarios here,
>> and "is this file rt?" is prescribed in different ways - either in
>> the dump itself, or on the target fs via inheritance flags...
>>
>> (NB: rt is not the only inheritable flag, so would we need to handle
>> the others?)
>>
>> non-rt fs dump, restored onto non-rt fs
>> 	- obviously this is fine
>>
>> rt fs dump, restored onto rt fs
>> 	- obviously this is fine as well
>>
>> rt fs dump, restored onto non-rt fs
>> 	- this works, with errors - all rt files become non-rt
>> 	- nothing else to do here other than fail outright
> 
> This should just work, without errors or warnings.

I said errors but I meant warnings:

xfsrestore: restoring non-directory files
xfsrestore: WARNING: attempt to set extended attributes (xflags 0x80000001, extsize = 0x0, projid = 0x0) of rtdir/bar failed: Invalid argument
xfsrestore: WARNING: attempt to set extended attributes (xflags 0x80000001, extsize = 0x0, projid = 0x0) of rtdir/baz failed: Invalid argument
xfsrestore: restore complete: 0 seconds elapsed

and yeah, probably should not be noisy there.

>> non-rt fs dump, restored into rt fs dir/fs with "rtinherit" set
>> 	- this one is your case
>> 	- today it's ignored, files stay non-rt
>> 	- you're suggesting it be honored and files turned into rt
> 
> Current filesystem policy should override the policy in dump image
> as the dump image may contain an invalid policy....
> 
>> the one case that's not handled here is "what if I want to have my
>> realtime dump with realtime files restored onto an rt-capable fs, but
>> turned into regular files?" 
> 
> Which is where having the kernel policy override the dump file is
> necesary...

The trick is that we don't have a "no-rt" flag we can set on a dir,
so there is no "files in this dir ar not rt" policy to follow.

>> So your patch gives us one mechanism (restore non-rt files as
>> rt files) but not the converse (restore rt files as non-rt files) -
>> I'm not sure if that matters, but the symmetry bugs me a little.
>>
>> I'm trying to decide if dump/restore is truly the right way to
>> migrate files from non-rt to rt or vice versa, TBH.  Maybe dchinner
>> or djwong will have thoughts as well...
> 
> *nod*
> 
> My take on this is that we need to decide which allocation policy to
> use - the kernel policy or the dump file policy - in the different
> situations. It's a simple, easy to document and understand solution.
> 
> At minimum, if there's a mismatch between rtdev/non-rtdev between
> dump and restore, then restore should not try to restore or clear rt
> flags at all. i.e the rt flags in the dump image should be
> considered invalid in this situation and masked out in the restore
> process. This prevents errors from being reported during restore,
> and it does "the right thing" according to how the user has
> configured the destination directory. i.e.  if the destdir has the
> rtinherit bit set and there's a rtdev present, the kernel policy
> will cause all file data that is restored to be allocated on the
> rtdev. Otherwise the kernel will place it (correctly) on the data
> dev.
> 
> In the case where both have rtdevs, but you want to restore to
> ignore the dump file rtdev policy, we really only need to add a CLI
> option to say "ignore rt flags" and that then allows the kernel
> policy to dictate how the restored files are placed in the same way
> that having a rtdev mismatch does.
> 
> This is simple, consistent, fulfils the requirements and should have
> no hidden surprises for users....

Sounds reasonable.  So the CLI flag would say "ignore RT info in the
dump, and write files according to the destination fs policy?"
I think that makes sense.

Now: do we need to do the same for all inheritable flags?  projid,
extsize, etc?  I think we probably do.

-Eric
